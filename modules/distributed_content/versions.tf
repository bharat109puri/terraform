terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.70"

      configuration_aliases = [aws.us-east-1]
    }
  }
}
