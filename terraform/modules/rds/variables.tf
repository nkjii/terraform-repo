# Global
variable region {}
variable name_prefix {}

# Tags
variable tag_name {}
variable tag_group {}

variable "db_name" {}

variable "db_username" {}

variable "db_password" {}

variable "vpc_id" {}

variable "subnet_ids" {
    type = list(string)
}

variable "rds_security_group_id" {}

variable "engine" {
    default = "mysql"
}

variable "engine_version" {
    default = "8.0"
}

variable "db_instance" {
    default = "db.t3.micro"
}