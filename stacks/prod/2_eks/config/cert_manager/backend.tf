terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "recrd"

    workspaces {
      name = "kubernetes__config__cert_manager"
    }
  }
}
