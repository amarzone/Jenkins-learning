terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Call the EC2 module to create an instance for Node.js
module "ec2_node" {
  source = "./modules/ec2"

  instance_name          = var.instance_name
  instance_type          = var.instance_type
  ami_id                 = var.ami_id
  key_pair_name          = var.key_pair_name
  security_group_ids     = var.security_group_ids
  subnet_id              = var.subnet_id
  associate_public_ip    = var.associate_public_ip
  environment            = var.environment
}

# Output the public IP of the created EC2 instance
output "ec2_public_ip" {
  description = "Public IP address of the Node.js EC2 instance"
  value       = module.ec2_node.public_ip
}

output "ec2_private_ip" {
  description = "Private IP address of the Node.js EC2 instance"
  value       = module.ec2_node.private_ip
}

output "ec2_instance_id" {
  description = "Instance ID of the created EC2 instance"
  value       = module.ec2_node.instance_id
}
