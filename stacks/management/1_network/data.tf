data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}


data "tfe_outputs" "staging_network" {
  organization = "recrd"
  workspace    = "staging_bootstrap"
}

data "tfe_outputs" "prod_network" {
  organization = "recrd"
  workspace    = "bootstrap"
}
