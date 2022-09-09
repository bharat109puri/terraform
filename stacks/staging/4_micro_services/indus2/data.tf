data "tfe_outputs" "bootstrap" {
  organization = "recrd"
  workspace    = "%{if var.env != ""}${var.env}_%{endif}bootstrap"
}

data "tfe_outputs" "kubernetes" {
  organization = "recrd"
  workspace    = "%{if var.env != ""}${var.env}_%{endif}kubernetes"
}

data "tfe_outputs" "angara" {
  organization = "recrd"
  workspace    = "%{if var.env != ""}${var.env}_%{endif}angara"
}
