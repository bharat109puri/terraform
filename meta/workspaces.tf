locals {
  # NOTE: Slashes are going to be replaced by double underscores in the workspace name
  workspaces = {
    bootstrap                                            = "Bootstrap - base-level, rarely changing resources"
    kubernetes                                           = "Kubernetes cluster - EKS resources",
    "kubernetes/config"                                  = "Kubernetes cluster - configuration",
    "kubernetes/config/actions_runner_controller"        = "GitHub Actions Runner controller",
    "kubernetes/config/actions_runner_controller/config" = "GitHub Actions Runner controller - configuration",
    "kubernetes/config/aws_load_balancer_controller"     = "AWS Load balancer controller",
    "kubernetes/config/cert_manager"                     = "Cert manager controller",
    "kubernetes/config/external_dns"                     = "ExternalDNS controller",
    "kubernetes/config/sealed_secrets"                   = "SealedSecrets controller",
    services                                             = "Common and shared resources for services",
    users                                                = "AWS IAM users and roles",
  }

  component_workspaces = {
    Web-FrontEnd = "Web frontend",
    angara       = "Orchestrator",
    congo        = "Content Creation and User Interests API",
    danube       = "Authentication Service",
    godavari     = "Analytics Engine",
    hello-world  = "Kubernetes example project",
    shared-data  = "Shared Data",
    volga        = "Kafka Choreographer",
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

  name         = replace(each.key, "/", "__")
  organization = tfe_organization.recrd.name

  description = each.value

  allow_destroy_plan    = false
  auto_apply            = false
  execution_mode        = "local" # TODO: AWS credentials
  file_triggers_enabled = true
  queue_all_runs        = true
  working_directory     = each.key

  vcs_repo {
    identifier     = "RecrdGroup/terraform"
    oauth_token_id = data.tfe_oauth_client.github_recrd_group.oauth_token_id
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "tfe_workspace" "component_repos" {
  for_each = local.component_workspaces

  name         = each.key
  organization = tfe_organization.recrd.name

  description = each.value

  allow_destroy_plan    = false
  auto_apply            = false
  execution_mode        = "local" # TODO: AWS credentials
  file_triggers_enabled = true
  queue_all_runs        = true
  working_directory     = "terraform"

  vcs_repo {
    identifier     = "RecrdGroup/${each.key}"
    oauth_token_id = data.tfe_oauth_client.github_recrd_group.oauth_token_id
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "tfe_run_trigger" "kubernetes" {
  workspace_id  = tfe_workspace.terraform_repo["kubernetes"].id
  sourceable_id = tfe_workspace.terraform_repo["bootstrap"].id
}

resource "tfe_run_trigger" "kubernetes_config" {
  workspace_id  = tfe_workspace.terraform_repo["kubernetes/config"].id
  sourceable_id = tfe_workspace.terraform_repo["kubernetes"].id
}
