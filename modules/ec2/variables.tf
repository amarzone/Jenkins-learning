variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
  validation {
    condition     = length(var.instance_name) > 0
    error_message = "Instance name must not be empty."
  }
}

variable "instance_type" {
  description = "Type of EC2 instance (e.g., t3.micro, t3.small)"
  type        = string
  default     = "t3.micro"
  validation {
    condition     = can(regex("^t[234]{1}\\.", var.instance_type)) || can(regex("^m[567]{1}\\.", var.instance_type))
    error_message = "Instance type must be a valid AWS instance type."
  }
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  validation {
    condition     = can(regex("^ami-", var.ami_id))
    error_message = "AMI ID must start with 'ami-'."
  }
}

variable "key_pair_name" {
  description = "Name of the EC2 Key Pair for SSH access"
  type        = string
  validation {
    condition     = length(var.key_pair_name) > 0
    error_message = "Key pair name must not be empty."
  }
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the instance"
  type        = list(string)
  default     = []
}

variable "aws_security_group" {
  description = "List of security group IDs to attach to the instance"
  type        = list(string)
  default     = ["sg-0b10a6039206f4f2a"]
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be created"
  type        = string
  default     = ""
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment name (e.g., development, staging, production)"
  type        = string
  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be one of: development, staging, production."
  }
}
