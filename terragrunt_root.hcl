# vim: set filetype=hcl
terragrunt_version_constraint = "0.35.16"

locals {
  aws_region = "eu-west-1"
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<-CONTENTS
    terraform {
      backend "remote" {
        hostname     = "app.terraform.io"
        organization = "recrd"

        workspaces {
          name = "${path_relative_to_include()}"
        }
      }
    }
  CONTENTS
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
