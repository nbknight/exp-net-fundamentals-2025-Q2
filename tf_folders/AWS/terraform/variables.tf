variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "az_count" {
  description = "Number of AZs to use"
  type        = number
  default     = 2
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs, one per AZ"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs, one per AZ"
  type        = list(string)
}

variable "my_ip_cidr" {
  description = "Your public IP in CIDR (for RDP access)"
  type        = string
}

variable "instance_count" {
  description = "Number of Windows instances"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "EC2 instance type for Windows"
  type        = string
  default     = "t3.large"
}

variable "key_name" {
  description = "Existing key pair name for SSH/RDP"
  type        = string
}

variable "name_prefix" {
  description = "Prefix to use for naming the Windows instances"
  type        = string
}
