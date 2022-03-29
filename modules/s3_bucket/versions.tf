terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.70, < 4.0.0" # FIXME: Upgrade to v4
    }
  }
}
