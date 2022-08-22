terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.7.1"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "../../kubeconfig.yaml"
  }
}

provider "kubernetes" {
  config_path = "../../kubeconfig.yaml"
}
