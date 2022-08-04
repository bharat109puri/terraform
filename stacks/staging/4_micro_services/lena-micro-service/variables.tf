variable "region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "deployment environment"
  type        = string
}

variable "tfe_token" {
  description = "Terraform Cloud Team token"
  type        = string
  sensitive   = true
}
