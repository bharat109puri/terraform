data "tfe_outputs" "bootstrap" {
  organization = "recrd"
  workspace    = join("_", ["${var.env}", "bootstrap"])
}

data "tfe_outputs" "kubernetes" {
  organization = "recrd"
  workspace    = join("_", ["${var.env}", "kubernetes"])
}

data "tfe_outputs" "angara" {
  organization = "recrd"
  workspace    = join("_", ["${var.env}", "angara"])
}
