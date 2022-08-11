terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.1.0"
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

provider "tfe" {
  token = var.tfe_token
}
