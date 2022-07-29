data "tfe_outputs" "bootstrap" {
  organization = "recrd"
  workspace    = "bootstrap"
}

data "tfe_outputs" "kubernetes" {
  organization = "recrd"
  workspace    = "kubernetes"
}

data "tfe_outputs" "angara" {
  organization = "recrd"
  workspace    = "angara"
}
