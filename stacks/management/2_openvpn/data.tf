data "aws_caller_identity" "current" {}

data "tfe_outputs" "network" {
  organization = "recrd"
  workspace    = "management_network"
}
