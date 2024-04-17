# Global
variable region {}
variable name_prefix {}

# Tags
variable tag_name {}
variable tag_group {}

# cidr_block
variable public_a_cidr {}
variable public_c_cidr {}
variable private_a_cidr {}
variable private_c_cidr {}

# Internet Gateway

locals {
  vpc_cidr = "10.0.0.0/16"
}
