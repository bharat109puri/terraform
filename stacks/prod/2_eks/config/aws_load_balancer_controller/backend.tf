terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "recrd"

    workspaces {
      name = "kubernetes__config__aws_load_balancer_controller"
    }
  }
}
