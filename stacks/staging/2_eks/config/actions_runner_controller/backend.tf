terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "recrd"

    workspaces {
      name = "stage_kubernetes__config__actions_runner_controller"
    }
  }
}
