## VPC Settings

These are the VPC settings I would like to setup using Terraform (for easy build and shutdown to save money).
- VPC with IPv4 CIDR Block: 10.200.123.0/24
- IPv6 CIDR: no
- Number of AZs: 2
- Number of PVT Subnets: 2
- Number of PUB Subnets: 2
- Number of IGW: 1
- Number of NATs: 0
- VPC Endpoints: 0
- DNS Options: Enable DNS Hostnames
- DNS Options: Enable DNS Resolution

# VM Settings

- Number of VMs: 1
- VM Image: Windows Server 2025 Base Latest
- Instance Size: t3.large
- Root Volume: 30gb gp3
- Number of Key Pairs: 1
  - nwbootcampkey-pem.pem (already created)
- Number of NICs: 2 per VM
- Number of Security Groups: 1
  - Outbound Rule: 0.0.0.0/0 | All traffic
  - Inbound Rule: My IP | 3389 (RDP)
  - Inbound Rule: 10.200.123.0/24 | All traffic <Allows vpc traffic from anything in the VPC>
- Auto Assign Public IP: Yes

## Need to create an s3 bucket for the s3 backend:
aws s3api create-bucket \
  --bucket nwbootcamp-tfstate-bucket \
  --region us-east-1

aws dynamodb create-table \
  --table-name terraform-lock-table \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST

