terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
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

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  config_path = "../../terraform/kubernetes/kubeconfig.yaml" # FIXME
}

provider "tfe" {
  token = var.tfe_token
}
