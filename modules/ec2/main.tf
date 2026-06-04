resource "aws_instance" "main" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = var.subnet_id != "" ? var.subnet_id : null
  vpc_security_group_ids      = length(var.security_group_ids) > 0 ? var.security_group_ids : null
  associate_public_ip_address = var.associate_public_ip

  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
}
