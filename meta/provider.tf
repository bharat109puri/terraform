# FIXME
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
    tfe = {
      version = "~> 0.27"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "tfe" {}
