resource "aws_subnet" "public_a" {
  cidr_block        = var.public_a_cidr
  vpc_id            = aws_vpc.default.id
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.tag_name}-subnet-a"
    group = "${var.tag_group}"
  }
}

resource "aws_subnet" "public_c" {
  cidr_block        = var.public_c_cidr
  vpc_id            = aws_vpc.default.id
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${var.tag_name}-subnet-c"
    group = "${var.tag_group}"
  }
}

resource "aws_subnet" "private_a" {
  cidr_block        = var.private_a_cidr
  vpc_id            = aws_vpc.default.id
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.tag_name}-subnet-a"
    group = "${var.tag_group}"
  }
}

resource "aws_subnet" "private_c" {
  cidr_block        = var.private_c_cidr
  vpc_id            = aws_vpc.default.id
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${var.tag_name}-subnet-c"
    group = "${var.tag_group}"
  }
}