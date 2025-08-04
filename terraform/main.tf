provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      Owner       = "DevOps Team"
      ManagedBy   = "Terraform"
    }
  }
}

# Backend Module
module "backend" {
  source = "./modules/backend"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  mongodb_uri        = var.mongodb_uri
  port               = var.port
  jwt_secret         = var.jwt_secret
}