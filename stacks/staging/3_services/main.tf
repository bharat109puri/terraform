data "aws_caller_identity" "current" {}

data "tfe_outputs" "bootstrap" {
  organization = "recrd"
  workspace    = "staging_bootstrap"
}

data "tfe_outputs" "users" {
  organization = "recrd"
  workspace    = "users"
}
