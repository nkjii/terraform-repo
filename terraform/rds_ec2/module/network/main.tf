#----------------------------------------
# VPCの作成
#----------------------------------------
resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name}-vpc"
  }
}
#----------------------------------------
# パブリックサブネットの作成
#----------------------------------------
  resource "aws_subnet" "public" {
    for_each = var.pub_cidrs

    vpc_id                  = aws_vpc.default.id
    cidr_block              = each.value
    availability_zone       = "${var.region}${each.key}"
    map_public_ip_on_launch = true
    tags = {
      Name = "${var.name}-public-${each.key}"
    }
  }
#----------------------------------------
# プライベートサブネットの作成
#----------------------------------------
resource "aws_subnet" "private" {
  for_each = var.pri_cidrs

  vpc_id                  = aws_vpc.default.id
  cidr_block              = each.value
  availability_zone       = "${var.region}${each.key}"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-private-${each.key}"
  }
}
#----------------------------------------
# ルートテーブルの作成
#----------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
  tags = {
    Name = "${var.name}-public-rtb"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.default.id
  }
  tags = {
    Name = "${var.name}-private-rtb"
  }
}
#----------------------------------------
# サブネットにルートテーブルを紐づけ
#----------------------------------------
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
#----------------------------------------
# セキュリティグループの作成
#----------------------------------------
resource "aws_security_group" "default" {
  name   = "sample-sg"
  vpc_id = aws_vpc.default.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#----------------------------------------
# インターネットゲートウェイの作成
#----------------------------------------
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "${var.name}-igw"
  }
}
#----------------------------------------
# NATゲートウェイの作成
#----------------------------------------
resource "aws_nat_gateway" "default" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public["a"].id
  depends_on    = [aws_internet_gateway.default]
}
resource "aws_eip" "nat" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.default]
}