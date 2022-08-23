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

#NOTE: required for distributed_content module
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "kubernetes" {
  config_path = var.kubernetes_config_path # FIXME
}

provider "tfe" {
  token = var.tfe_token
}
