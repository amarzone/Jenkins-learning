variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.aws_region))
    error_message = "Invalid AWS region format."
  }
}
