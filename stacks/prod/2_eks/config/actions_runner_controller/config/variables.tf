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
  default     = "../../../kubeconfig.yaml"
}
