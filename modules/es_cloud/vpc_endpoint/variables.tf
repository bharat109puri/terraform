variable "allowed_security_group_ids" {
  description = "Security group IDs allowed to talk to Elastic VPC endpoint"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Elastic VPC endpoint"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the Elastic VPC endpoint"
  type        = string
}
