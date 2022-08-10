terraform {
  required_providers {
    astra = {
      source  = "datastax/astra"
      version = "2.0.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.28.1"
    }
  }
}

provider "astra" {
  token = var.astra_token
}

provider "aws" {
  region = var.region
}

provider "tfe" {
  token = var.tfe_token
}