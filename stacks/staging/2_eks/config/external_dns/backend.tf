terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "recrd"

    workspaces {
      name = "staging_kubernetes__config__external_dns"
    }
  }
}
