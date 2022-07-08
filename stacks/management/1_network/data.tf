data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}


data "tfe_outputs" "staging_network" {
  organization = "recrd"
  workspace    = "staging_network"
}