resource "aws_db_subnet_group" "sub_group" {
    name       = "${var.env}-db-subnet-group"
    subnet_ids = var.private_subnet_ids
    tags = {
        Name = "${var.env}-db-subnet-group"
    }
}

resource "aws_db_instance" "db_instance" {
    engine                  = "postgres"
    engine_version          = "15.4"
    identifier              = "${var.env}-db"
    username                = var.db_username
    password                = var.db_password
    db_subnet_group_name    = aws_db_subnet_group.sub_group.name
    vpc_security_group_ids  = [var.rds_sg_id]
    skip_final_snapshot     = true
    instance_class          = var.db_instance_class
    allocated_storage       = 20
    backup_retention_period = var.backup_retention_period
    deletion_protection     = var.deletion_protection
}
