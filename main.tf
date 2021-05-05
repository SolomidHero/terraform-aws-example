terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# Create a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    name = "ExampleVPC"
  }
}

# Create machine image
data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"] # free tier image of Canonical
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "nginx_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  # VPC association
  subnet_id = aws_subnet.example_subnet[0].id
  vpc_security_group_ids = [aws_security_group.example_sgp.id]

  # nginx installation
  user_data = file("nginx.sh")

  tags = {
    Environment = "production"
    Name        = "NginxServer"
  }
}

resource "aws_instance" "apache_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  # VPC association
  subnet_id = aws_subnet.example_subnet[1].id
  vpc_security_group_ids = [aws_security_group.example_sgp.id]

  # apache installation
  user_data = file("apache.sh")

  tags = {
    Environment = "production"
    Name        = "ApacheServer"
  }
}