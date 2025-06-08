terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "nwbootcamp-tfstate-bucket"       # replace with your bucket
    key            = "bootcamp/terraform.tfstate"
    region         = "us-east-1"                 # the region your state lives in
    dynamodb_table = "terraform-lock-table"      # for state locking
  }
}

provider "aws" {
  region = var.aws_region
}
