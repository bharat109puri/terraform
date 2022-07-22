data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "tfe_outputs" "management" {
  organization = "recrd"
  workspace    = "management_network"
}