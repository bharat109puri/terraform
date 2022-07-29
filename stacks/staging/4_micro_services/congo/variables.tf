variable "region" {
  description = "AWS region"
  type        = string
}

variable "tfe_token" {
  description = "Terraform Cloud Team token"
  type        = string
  sensitive   = true
}

variable "managed_response_headers_policy_id" {
  description = "Managed-CORS-With-Preflight"
  type        = string
  default     = "5cc3b908-e619-4b99-88e5-2cf7f45965bd"
}

variable "env" {
  description = "current environment"
  type        = string
  default     = ""
}
