# vim: set filetype=hcl
terragrunt_version_constraint = "0.35.16"

locals {
  aws_region = "eu-west-1"
}

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket         = "recrd-terraform"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<-CONTENTS
    terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "3.70.0"
        }
      }
    }

    provider "aws" {
      region = "${local.aws_region}"
    }
  CONTENTS
}
