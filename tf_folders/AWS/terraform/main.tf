#1) Data blocks are on the data.tf

# 2) VPC
resource "aws_vpc" "bootcamp" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "bootcamp-vpc" }
}

# 3) Internet Gateway + Public Route Table
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.bootcamp.id
  tags   = { Name = "bootcamp-igw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.bootcamp.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "bootcamp-public-rt" }
}

# 4) Subnets
locals {
  azs = slice(data.aws_availability_zones.azs.names, 0, var.az_count)
}

# Public subnets
resource "aws_subnet" "public" {
  for_each = { for idx, az in local.azs : az => var.public_subnet_cidrs[idx] }
  vpc_id                  = aws_vpc.bootcamp.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = { Name = "bootcamp-public-${each.key}" }
}

# Private subnets
resource "aws_subnet" "private" {
  for_each = { for idx, az in local.azs : az => var.private_subnet_cidrs[idx] }
  vpc_id            = aws_vpc.bootcamp.id
  cidr_block        = each.value
  availability_zone = each.key
  tags = { Name = "bootcamp-private-${each.key}" }
}

# Associate public RT with each pub subnet
resource "aws_route_table_association" "public_assoc" {
  for_each      = aws_subnet.public
  subnet_id     = each.value.id
  route_table_id = aws_route_table.public.id
}

# 5) Security Group for Windows RDP + VPC traffic
resource "aws_security_group" "win_sg" {
  name        = "bootcamp-windows-sg"
  description = "Allow RDP from my IP + all VPC traffic"
  vpc_id      = aws_vpc.bootcamp.id

  ingress {
    description      = "RDP from my IP"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip_cidr]
  }

  ingress {
    description = "All VPC traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "bootcamp-win-sg" }
}

# 6) Windows instance module
module "windows_server" {
  source             = "./modules/windows_server"
  ami_id             = data.aws_ami.win2025.id
  instance_type      = var.instance_type
  key_name           = aws_key_pair.bootcamp.key_name
  subnet_public_ids  = values(aws_subnet.public)[*].id
  subnet_private_ids = values(aws_subnet.private)[*].id
  security_group_ids = [aws_security_group.win_sg.id]
  instance_count     = var.instance_count
  name_prefix        = var.name_prefix
}
