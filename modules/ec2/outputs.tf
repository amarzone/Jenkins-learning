output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.main.id
  value       = module.ec2_node.main.id
}

output "public_ip" {
  description = "Public IP address of the instance"
  value       = module.ec2_node.public_ip
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = module.ec2_node.private_ip
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       =module.ec2_node.arn
}

output "instance_state" {
  description = "Current state of the instance"
  value       = module.ec2_node.instance_state
}

output "availability_zone" {
  description = "Availability zone of the instance"
  value       = module.ec2_node.availability_zone
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = length(var.security_group_ids) > 0 ? var.security_group_ids[0] : aws_security_group.ec2_sg[0].id
}

output "vpc_security_group_ids" {
  description = "List of all security group IDs attached to the instance"
  value       = module.ec2_node.vpc_security_group_ids
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i /path/to/${var.key_pair_name}.pem ec2-user@${module.ec2_node.public_ip}"
}
