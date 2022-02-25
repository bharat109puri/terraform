locals {
  # NOTE: Underscores are handled as subdirectories
  workspaces = {
    bootstrap         = "[TEST] Bootstrap"
    example_cassandra = "[EXAMLPE] DataStax Astra - Serverless Cassandra"
    kubernetes        = "[TEST] Kubernetes",
    kubernetes_config = "[TEST] Kubernetes configuration and core services",
    users             = "AWS IAM users and roles",
  }
}

data "tfe_oauth_client" "github_recrd_group" {
  oauth_client_id = "oc-o8zZk3JtWFW3m13k"
}

resource "tfe_workspace" "meta" {
  name         = "meta"
  organization = tfe_organization.recrd.name

  description = "Managing Terraform Cloud"

  allow_destroy_plan    = false
  auto_apply            = false
  execution_mode        = "local" # FIXME: remote? (tfe_organization requires user token)
  file_triggers_enabled = false
  queue_all_runs        = false
  working_directory     = "meta"

  vcs_repo {
    identifier     = "RecrdGroup/terraform"
    oauth_token_id = data.tfe_oauth_client.github_recrd_group.oauth_token_id
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "tfe_workspace" "terraform_repo" {
  for_each = local.workspaces

  name         = each.key
  organization = tfe_organization.recrd.name

  description = each.value

  allow_destroy_plan    = false
  auto_apply            = false
  execution_mode        = "local" # FIXME: AWS credentials
  file_triggers_enabled = true
  queue_all_runs        = true
  working_directory     = replace(each.key, "_", "/")

  vcs_repo {
    identifier     = "RecrdGroup/terraform"
    oauth_token_id = data.tfe_oauth_client.github_recrd_group.oauth_token_id
  }
}

resource "tfe_run_trigger" "kubernetes" {
  workspace_id  = tfe_workspace.terraform_repo["kubernetes"].id
  sourceable_id = tfe_workspace.terraform_repo["bootstrap"].id
}

resource "tfe_run_trigger" "kubernetes_config" {
  workspace_id  = tfe_workspace.terraform_repo["kubernetes_config"].id
  sourceable_id = tfe_workspace.terraform_repo["kubernetes"].id
}
