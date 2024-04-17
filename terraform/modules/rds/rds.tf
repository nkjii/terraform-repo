resource "aws_db_instance" "db_instance" {
    allocated_storage               = 10
    storage_type                    = "gp2"
    engine                          = var.engine
    engine_version                  = var.engine_version
    instance_class                  = var.db_instance
    identifier                      = var.db_name
    username                        = var.db_username
    password                        = var.db_password
    db_name                         = var.db_name
    port                            = 3306
    copy_tags_to_snapshot           = true
    db_subnet_group_name            = aws_db_subnet_group.db_subnet_group.name
    vpc_security_group_ids          = [var.rds_security_group_id]
    skip_final_snapshot             = true
}

resource "aws_db_subnet_group" "db_subnet_group" {
    name = "${var.name_prefix}-db-subnet"
    subnet_ids = var.subnet_ids
    description = "DB Subnet Group"
}