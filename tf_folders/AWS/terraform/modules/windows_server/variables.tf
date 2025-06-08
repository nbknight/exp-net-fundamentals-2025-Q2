variable "ami_id" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "key_name" {
  type = string
}
variable "subnet_public_ids" {
  type = list(string)
}
variable "subnet_private_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type = list(string)
}
variable "instance_count" {
  type    = number
  default = 1
}
variable "root_volume_size" {
  type    = number
  default = 30
}

variable "name_prefix" {
  description = "Prefix to use for naming the Windows instances"
  type        = string
  default     = "win"
}

