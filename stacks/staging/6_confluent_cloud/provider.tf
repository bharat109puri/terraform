terraform {
  required_providers {
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


provider "tfe" {
  token = var.tfe_token
}
