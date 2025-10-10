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

# Create a VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

   tags = {Name = "${var.project_name}-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {Name = "${var.project_name}-igw" }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.demo_vpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true 

  tags = {Name = "${var.project_name}-public-subnet" }
  }

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.demo_vpc.id
  cidr_block = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = {Name = "${var.project_name}-private-subnet" }
  }

  resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.demo_vpc.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
   }
    tags = {Name = "${var.project_name}-public-rt"}

  }

  resource "aws_route_table_association" "public_rt_assoc" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
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