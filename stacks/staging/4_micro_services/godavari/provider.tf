terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
    ec = {
      source  = "elastic/ec"
      version = "0.4.0"
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

provider "ec" {
  apikey = var.ec_token
}

provider "tfe" {
  token = var.tfe_token
}
