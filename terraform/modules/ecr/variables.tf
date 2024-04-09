# Global
variable region {}
variable name_prefix {}

# Tags
variable tag_name {}
variable tag_group {}

# ECR
variable "account_id" {}

locals {
  repository_name = "${var.name_prefix}-repository"
  container_name = "${var.name_prefix}-container"
  docker_dir = "/home/ec2-user/environment/terraform-repo/go-training"
}
