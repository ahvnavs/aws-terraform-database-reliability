env                     = "prod"
aws_region              = "ap-south-1"
vpc_cidr                = "10.1.0.0/16"
db_username             = "postgres"
db_password             = "ProdSuperSecret!"
db_instance_class       = "db.t3.large"   
backup_retention_period = 30
deletion_protection     = true
