variable "region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "name of the environment"
}

variable "tfe_token" {
  description = "Terraform Cloud Team token"
  type        = string
  sensitive   = true
}

