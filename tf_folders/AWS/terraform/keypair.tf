resource "tls_private_key" "bootcamp" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bootcamp" {
  key_name   = "nwbootcampkey"                  # your chosen name
  public_key = tls_private_key.bootcamp.public_key_openssh
}

resource "local_file" "bootcamp_key_pem" {
  content         = tls_private_key.bootcamp.private_key_pem
  filename        = "${path.root}/nwbootcampkey.pem"
  file_permission = "0400"
}
