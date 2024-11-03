# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


#VPC CREATION
resource "aws_vpc" "vpc_terraform" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = "true"

  tags = {
    Name = "vpc_terraform"
  }
} 


#INTERNET GATEWAY 
resource "aws_internet_gateway" "terra-igw" {
  vpc_id = aws_vpc.vpc_terraform.id

  tags = {
    Name = "terra-igw"
  }
}


#SUBNET CRATION
resource "aws_subnet" "public-subnet-terra-1" {
  vpc_id     = aws_vpc.vpc_terraform.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public-subnet-terra-1"
  }
}

#ROUTE TABLE CREATION
resource "aws_route_table" "Public-RT-terra" {
  vpc_id = aws_vpc.vpc_terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-igw.id
  }


  tags = {
    Name = "Public-RT-terra"
    Service = "Terraform"
  }
}


#ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "Public-RT-terra-association" {
  subnet_id      = aws_subnet.public-subnet-terra-1.id
  route_table_id = aws_route_table.Public-RT-terra.id
}


#SECURITY GROUPS
resource "aws_security_group" "Pub-Terra-SG" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc_terraform.id

  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Pub-Terra-SG"
  }
}
