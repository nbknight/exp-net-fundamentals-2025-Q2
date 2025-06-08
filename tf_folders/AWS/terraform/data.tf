# 1) Fetch AZs and AMI
data "aws_availability_zones" "azs" {
  state = "available"
}

data "aws_ami" "win2025" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2025-English-Full-Base-*"]
  }
}