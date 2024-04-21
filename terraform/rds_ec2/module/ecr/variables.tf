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
  docker_dir = "/web/app/docker-compose.yml"
}


