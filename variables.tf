variable "aws_region" {
  type = string
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
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
