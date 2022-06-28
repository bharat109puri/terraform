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
    awsutils = {
      source  = "cloudposse/awsutils"
      version = "0.8.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "awsutils" {
  region = var.region
}

provider "tfe" {
  token = var.tfe_token
}
