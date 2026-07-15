terraform {
  required_version = ">= 1.5.0"
  #backend "s3" {
  #  bucket       = "terraform-state-bucket"
  #  key          = "dev/terraform.tfstate"
  #  region       = "ap-south-1"
  #  encrypt      = true
  #  use_lockfile = true
  #}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = var.aws_region
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}

module "network" {
  source = "../../modules/network"
  env    = var.env
  cidr   = [var.vpc_cidr, "10.1.1.0/24", "10.1.2.0/24", "10.1.11.0/24", "10.1.12.0/24"]
}

module "security_groups" {
  source = "../../modules/security_groups"
  env    = var.env
  vpc_id = module.network.vpc_id
}

module "rds" {
  source                  = "../../modules/rds"
  env                     = var.env
  private_subnet_ids      = module.network.private_subnet_ids
  rds_sg_id               = module.security_groups.rds_sg_id
  db_instance_class       = var.db_instance_class
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
  db_password             = var.db_password
  db_username             = var.db_username
}

module "ecs" {
  source             = "../../modules/ecs"
  env                = var.env
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  alb_sg_id          = module.security_groups.alb_sg_id
  ecs_sg_id          = module.security_groups.ecs_sg_id
}
