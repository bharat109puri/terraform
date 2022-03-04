variable "astra_token" {
  description = "DataStax Astra API Administrator Service Account token"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "tfe_token" {
  description = "Terraform Cloud Team token"
  type        = string
  sensitive   = true
}
