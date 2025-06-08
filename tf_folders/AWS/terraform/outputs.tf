output "vpc_id" {
  value = aws_vpc.bootcamp.id
}

output "windows_instance_ids" {
  value = module.windows_server.instance_ids
}

output "windows_public_ips" {
  value = module.windows_server.public_ips
}

output "bootcamp_private_key_pem" {
  description = "PEM-encoded private key for RDP"
  value       = tls_private_key.bootcamp.private_key_pem
  sensitive   = true
}

output "bootcamp_key_name" {
  description = "The EC2 KeyPair name"
  value       = aws_key_pair.bootcamp.key_name
}

