terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.7.1"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.28.1"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubernetes_config_path
}

provider "tfe" {
  token = var.tfe_token
}
