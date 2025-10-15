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
    value = aws_vpc.demo_vpc.id
  }
  output "public_subnet_id" {
    value = aws_subnet.public_subnet.id
  }
  output "private_subnet_id" {
    value = aws_subnet.private_subnet.id
  }