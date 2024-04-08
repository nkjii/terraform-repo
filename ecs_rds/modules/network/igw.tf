resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.tag_name}-internet-gateway"
    group = "${var.tag_group}"
  }
}
