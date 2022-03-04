terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "recrd"

    workspaces {
      name = "kubernetes_config"
    }
  }
}
