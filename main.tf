terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        
        }
    }

    backend "s3" {
        bucket = "hadassah-s3bucket"
        key    = "terraform.tfstate"
        region = "eu-north-1"
    }
}



provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  region               = var.region
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
  availability_zone    = var.availability_zone
}

output "vpc_id" {
  value = module.vpc.vpc_id
} 
output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}