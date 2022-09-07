variable "inline_policy" {
  description = "Inline policy for the role"
  type        = string
}

variable "name" {
  description = "Kubernetes `ServiceAccount` name"
  type        = string

  validation {
    condition     = can(regex("[a-z0-9-]*", var.name))
    error_message = "Use lowercase alphanumeric characters or '-'."
  }
}

variable "environment" {
  description = "Enironment where `ServiceAccount` would be created"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("[a-z0-9-]*", var.environment))
    error_message = "Use lowercase alphanumeric characters or '-'."
  }
}

variable "namespace" {
  description = "Kubernetes namespace for the `ServiceAccount` (must exist)"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN exposed by Kubernetes"
  type        = string
}
