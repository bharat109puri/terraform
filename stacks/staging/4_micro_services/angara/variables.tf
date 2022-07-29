variable "region" {
  description = "AWS region"
  type        = string
}

variable "tfe_token" {
  description = "Terraform Cloud Team token"
  type        = string
  sensitive   = true
}

variable "env" {
  description = "current environment"
  type        = string
  default     = ""
}
