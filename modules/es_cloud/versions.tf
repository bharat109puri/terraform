terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.70.0"
    }
    ec = {
      source  = "elastic/ec"
      version = ">= 0.4.0"
    }
  }
}
