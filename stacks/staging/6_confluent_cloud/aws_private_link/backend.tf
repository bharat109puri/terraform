terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "recrd"

    workspaces {
      name = "staging_confluent_cloud_private_link"
    }
  }
}
