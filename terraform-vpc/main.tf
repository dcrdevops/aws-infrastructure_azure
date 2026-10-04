# =========================
# VPC
# =========================

resource "aws_vpc" "devops_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "AzureDevOps-Terraform-VPC"
  }
}


# =========================
# INTERNET GATEWAY
# =========================

resource "aws_internet_gateway" "devops_igw" {
  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name = "AzureDevOps-Terraform-IGW"
  }
}


# =========================
# PUBLIC SUBNET
# =========================

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "AzureDevOps-Terraform-Public-Subnet"
  }
}


# =========================
# ROUTE TABLE
# =========================

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.devops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_igw.id
  }

  tags = {
    Name = "AzureDevOps-Terraform-Public-RT"
  }
}


# =========================
# ROUTE TABLE ASSOCIATION
# =========================

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}


# =========================
# SECURITY GROUP
# =========================

resource "aws_security_group" "web_sg" {
  name        = "azure-devops-web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.devops_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AzureDevOps-Terraform-Web-SG"
  }
}


# =========================
# EC2
# =========================

resource "aws_instance" "web_server" {
  ami           = "ami-0d27e0fb3bac4d724"
  instance_type = var.instance_type

  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids     = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "AzureDevOps-Terraform-Web-EC2"
  }
}