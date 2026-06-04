variable "aws_region" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "subnet_id" {
  type = string
}

variable "associate_public_ip" {
  type = bool
}

variable "environment" {
  type = string
}
``
