data "tfe_outputs" "bootstrap" {
  organization = "recrd"
  workspace    = "staging_bootstrap"
}

data "tfe_outputs" "kubernetes" {
  organization = "recrd"
  workspace    = "staging_kubernetes"
}