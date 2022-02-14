# FIXME
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.7.1"
    }
    tfe = {
      version = "~> 0.27"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "helm" {
  kubernetes {
    config_path = "../kubeconfig.yaml"
  }
}

provider "kubernetes" {
  config_path = "../kubeconfig.yaml"
}

provider "tfe" {}
