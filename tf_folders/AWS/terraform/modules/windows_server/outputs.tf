output "instance_ids" {
  value = aws_instance.win[*].id
}

output "public_ips" {
  value = aws_instance.win[*].public_ip
}

output "private_ips" {
  value = aws_instance.win[*].private_ip
}
