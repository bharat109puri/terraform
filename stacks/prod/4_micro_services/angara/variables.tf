variable "region" {
  description = "AWS region"
  type        = string
}

variable "tfe_token" {
  description = "Terraform Cloud Team token"
  type        = string
  sensitive   = true
}

variable "kubernetes_config_path" {
  description = "path to kubernetes configuration file"
  type        = string
  default     = "../../2_eks/kubeconfig.yaml"
}
