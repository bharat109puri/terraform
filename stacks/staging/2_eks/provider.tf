terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.28.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "tfe" {
  token = var.tfe_token
}

provider "helm" {
  kubernetes {
    config_path = "./kubeconfig.yaml"
  }
}
