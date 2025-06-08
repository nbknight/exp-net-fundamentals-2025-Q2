resource "aws_network_interface" "primary" {
  count           = var.instance_count
  subnet_id       = var.subnet_public_ids[count.index % length(var.subnet_public_ids)]
  security_groups = var.security_group_ids

  tags = {
    Name = "win-primary-eni-${count.index + 1}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_network_interface" "backup" {
  count           = var.instance_count
  # pick the “next” public subnet for redundancy
  subnet_id       = aws_network_interface.primary[count.index].subnet_id
  security_groups = var.security_group_ids

  tags = {
    Name = "win-backup-eni-${count.index + 1}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_instance" "win" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interface {
    network_interface_id         = aws_network_interface.primary[count.index].id
    device_index                 = 0
  }

  network_interface {
    network_interface_id         = aws_network_interface.backup[count.index].id
    device_index                 = 1
  }

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.name_prefix}-${count.index + 1}"
  }

  depends_on = [
    aws_network_interface.primary,
    aws_network_interface.backup,
  ]
}

# Primary interface gets its own Elastic IP
resource "aws_eip" "primary" {
  count             = var.instance_count
  network_interface = aws_network_interface.primary[count.index].id
  depends_on        = [ aws_instance.win ]
}

# Backup interface also gets an Elastic IP
resource "aws_eip" "backup" {
  count             = var.instance_count
  network_interface = aws_network_interface.backup[count.index].id
  depends_on        = [ aws_instance.win ]
}

