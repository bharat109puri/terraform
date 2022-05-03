variable "inline_policy" {
  description = "Inline policy for the role"
  type        = string
}

variable "oidc_provider_arn" {
  description = "GitHub OIDC provider ARN (from bootstrap)"
  type        = string
}

variable "repo_name" {
  description = "GitHub repo name (without `RecrdGroup/` organisation)"
  type        = string
}

variable "role_suffix" {
  description = "Role name suffix"
  type        = string
  default     = "github-actions"
}
