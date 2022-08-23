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
  config_path = "../../../kubeconfig.yaml"
}

provider "tfe" {
  token = var.tfe_token
}
