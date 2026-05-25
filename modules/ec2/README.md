# EC2 Module

This Terraform module creates an AWS EC2 instance with enhanced security features and comprehensive configuration options.

## Features

- ✅ **Security Best Practices**
  - IMDSv2 enforcement (prevents SSRF attacks)
  - Encrypted EBS volumes (gp3)
  - CloudWatch detailed monitoring enabled
  - Configurable security groups

- ✅ **Flexible Configuration**
  - Custom instance types (t3, m5, m6, etc.)
  - Custom AMI support
  - Public/Private IP control
  - VPC subnet support
  - Comprehensive tagging strategy

## Module Structure

```
modules/ec2/
├── main.tf              # EC2 instance and security group resources
├── variables.tf         # Input variables with validation
├── outputs.tf           # Module outputs
├── versions.tf          # Provider requirements
└── README.md            # This file
```

## Usage

### Basic Example

```hcl
module "ec2_instance" {
  source = "./modules/ec2"

  instance_name       = "my-jenkins-instance"
  instance_type       = "t3.micro"
  ami_id              = "ami-0c55b159cbfafe1f0"
  key_pair_name       = "my-key-pair"
  associate_public_ip = true
  environment         = "development"
}
```

### Advanced Example with Custom Security Groups

```hcl
module "ec2_instance" {
  source = "./modules/ec2"

  instance_name       = "my-app-server"
  instance_type       = "t3.small"
  ami_id              = "ami-0c55b159cbfafe1f0"
  key_pair_name       = "production-key"
  security_group_ids  = [aws_security_group.custom_sg.id]
  subnet_id           = aws_subnet.private.id
  associate_public_ip = false
  environment         = "production"
}
```

## Input Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `instance_name` | string | - | Name of the EC2 instance |
| `instance_type` | string | `t3.micro` | EC2 instance type |
| `ami_id` | string | - | AMI ID to use for the instance |
| `key_pair_name` | string | - | EC2 Key Pair name for SSH access |
| `security_group_ids` | list(string) | `[]` | Custom security group IDs |
| `subnet_id` | string | `""` | VPC subnet ID |
| `associate_public_ip` | bool | `true` | Associate public IP address |
| `environment` | string | - | Environment name (development/staging/production) |

## Outputs

| Output | Description |
|--------|-------------|
| `instance_id` | The ID of the EC2 instance |
| `public_ip` | Public IP address of the instance |
| `private_ip` | Private IP address of the instance |
| `instance_arn` | ARN of the instance |
| `instance_state` | State of the instance |
| `availability_zone` | Availability zone of the instance |
| `security_group_id` | Security group ID |
| `vpc_security_group_ids` | All security group IDs |
| `ssh_command` | Pre-formatted SSH command |

## Security Features

### IMDSv2 Enforcement
- Requires session tokens for metadata access
- Prevents SSRF (Server-Side Request Forgery) attacks
- Enabled by default

### Encrypted Storage
- EBS root volume encryption enabled
- gp3 volume type for better performance
- 20GB default size

### Monitoring
- CloudWatch detailed monitoring enabled
- Can be used for alerting and diagnostics

### Network Security
- Default security group with:
  - SSH (port 22) - Open to 0.0.0.0/0
  - HTTP (port 80) - Open to 0.0.0.0/0
  - HTTPS (port 443) - Open to 0.0.0.0/0
  - All outbound traffic allowed

## Requirements

- Terraform >= 1.0
- AWS Provider >= 5.0
- Valid AWS credentials configured
- EC2 Key Pair already created in AWS

## Example Outputs

```
instance_id             = "i-0abcd1234efgh5678"
public_ip               = "203.0.113.42"
private_ip              = "10.0.1.100"
instance_arn            = "arn:aws:ec2:eu-north-1:123456789012:instance/i-0abcd1234efgh5678"
instance_state          = "running"
availability_zone       = "eu-north-1a"
security_group_id       = "sg-0abcd1234efgh5678"
ssh_command             = "ssh -i /path/to/key-pair.pem ec2-user@203.0.113.42"
```

## Notes

- The module automatically creates a security group if none are specified
- SSH access is open to the world (0.0.0.0/0) - consider restricting this in production
- For production environments, use private subnets and bastion hosts for access
- All resources are tagged with `Name`, `Environment`, and `ManagedBy` tags

## License

This module is provided as-is for educational purposes.
