#----------------------------------------
# EC2インスタンスの作成
#----------------------------------------

resource "aws_instance" "ec2" {
  ami                    = "ami-05b37ce701f85f26a" # Amazon Linux 
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ec2.id]
  iam_instance_profile = aws_iam_instance_profile.systems-manager.name
  key_name               = "myaccesskey"
  user_data = <<EOF
#! /bin/bash
sudo yum update -y
sudo yum install -y mysql
sudo yum install -y git-all
EOF
}

#--------------------------------------------------------------
# Security group
#--------------------------------------------------------------
resource "aws_security_group" "ec2" {
  name = "${var.app_name}-ec2-sg"

  description = "EC2 service security group for ${var.app_name}"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ec2_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id
}

#--------------------------------------------------------------
# IAM Role
#--------------------------------------------------------------

data "aws_iam_policy_document" "ec2" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "systems-manager" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "ec2" {
  name               = "${var.app_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2.json
}

resource "aws_iam_role_policy_attachment" "ec2" {
  role       = aws_iam_role.ec2.name
  policy_arn = data.aws_iam_policy.systems-manager.arn
}

resource "aws_iam_instance_profile" "systems-manager" {
  name = "${var.app_name}-ec2-instance-profile"
  role = aws_iam_role.ec2.name
}