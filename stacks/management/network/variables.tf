variable "name" {
  description = "Label used to prefix multiple resources"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "tfe_token" {
  description = "Terraform Cloud Team token"
  type        = string
  sensitive   = true
  default     = "SynI2fjDrXCngw.atlasv1.J7n4SYfp81d0ADdxj0lKbuiFtUL2fb9R2neMgIXDJT5QPezPjgnoA5NsT2xfzXJYwrU"
}

variable "vpc_cidr" {
  description = "VPC CIDR (specify a /16)"
  type        = string
}
