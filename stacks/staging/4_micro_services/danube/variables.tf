variable "region" {
  description = "AWS region"
  type        = string
}

variable "rest_api_authenticated_http" {
  default     = "https://466a-2001-4c4e-24c1-6700-82d-b87-3c68-7a00.ngrok.io/authenticated"
  description = "HTTP Address with HTTP Proxy integration that requires authorization"
  type        = string
}

variable "rest_api_unauthenticated_http" {
  default     = "https://466a-2001-4c4e-24c1-6700-82d-b87-3c68-7a00.ngrok.io/unauthenticated"
  description = "HTTP Address with HTTP Proxy integration that does not require authorization"
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

variable "kubernetes_config_path" {
  description = "path to kubernetes configuration file"
  type        = string
  default     = "../../terraform/kubernetes/kubeconfig.yaml" # FIXME
}
