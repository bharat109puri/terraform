terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "recrd"

    workspaces {
      name = "indus2"
    }
  }
}