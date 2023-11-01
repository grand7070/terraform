# terraform {
#   backend "s3" {
#     bucket         = "terraform-remote-state-bucket123"
#     key            = "dev/terraform.tfstate"
#     region         = "ap-northeast-2"
#     dynamodb_table = "TerraformStateLock"
#     encrypt        = true
#   }
# }
terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 4.0"
        }
    }
}

provider "aws" {
    region  = "ap-northeast-2"
    profile = "terraform"
}


module "vpc" {
  source = "../../modules/terraform-aws-vpc"

  env                = var.env
  availability_zones = var.availability_zones
  vpc_cidr           = var.vpc_cidr
}

module "security_group" {
  source = "../../modules/terraform-aws-security-group"

  vpc_id = module.vpc.vpc_id
}

module "lb" {
  source = "../../modules/terraform-aws-lb"

  vpc_id                         = module.vpc.vpc_id
  web_public_subnet_ids          = module.vpc.web_public_subnet_ids
  app_private_subnet_ids         = module.vpc.app_private_subnet_ids
  external_alb_security_group_id = module.security_group.external_alb_security_group_id
  internal_alb_security_group_id = module.security_group.internal_alb_security_group_id
}

module "rds" {
  source = "../../modules/terraform-aws-rds"

  db_security_group_id = module.security_group.db_security_group_id
  db_public_subnet_ids = module.vpc.db_private_subnet_ids
}

module "ec2" {
  source = "../../modules/terraform-aws-ec2"

  web_security_group_id  = module.security_group.web_security_group_id
  app_security_group_id  = module.security_group.app_security_group_id
  web_public_subnet_ids  = module.vpc.web_public_subnet_ids
  app_private_subnet_ids = module.vpc.app_private_subnet_ids
  web_target_group_arn   = module.lb.web_target_group_arn
  app_target_group_arn   = module.lb.app_target_group_arn
  internal_alb_dns_name  = module.lb.internal_alb_dns_name
  db_address = module.rds.rds_address
  db_name =  module.rds.rds_name
  db_username = module.rds.rds_username
  db_password = module.rds.rds_password
}