resource "tfe_workspace" "meta" {
  name         = "meta"
  organization = tfe_organization.recrd.name

  description = "Managing Terraform Cloud"

  allow_destroy_plan    = false
  auto_apply            = false
  execution_mode        = "local" # FIXME: remote? (tfe_organization requires user token)
  file_triggers_enabled = false
  queue_all_runs        = false
  trigger_prefixes      = ["meta"]
  working_directory     = "meta"

  #vcs_repo {
  #  identifier     =
  #  oauth_token_id =
  #}
}

resource "tfe_workspace" "users" {
  name         = "users"
  organization = tfe_organization.recrd.name

  description = "AWS IAM users and roles"

  allow_destroy_plan    = false
  auto_apply            = false
  execution_mode        = "local" # FIXME: AWS credentials
  file_triggers_enabled = true
  queue_all_runs        = true
  trigger_prefixes      = ["users"]
  working_directory     = "users"

  #vcs_repo {
  #  identifier     =
  #  oauth_token_id =
  #}
}

resource "tfe_workspace" "bootstrap" {
  name         = "bootstrap"
  organization = tfe_organization.recrd.name

  description = "[TEST] Bootstrap"

  allow_destroy_plan    = false
  auto_apply            = false
  execution_mode        = "local" # FIXME: AWS credentials
  file_triggers_enabled = true
  queue_all_runs        = true
  trigger_prefixes      = ["bootstrap"]
  working_directory     = "bootstrap"

  #vcs_repo {
  #  identifier     =
  #  oauth_token_id =
  #}
}

resource "tfe_workspace" "kubernetes" {
  name         = "kubernetes"
  organization = tfe_organization.recrd.name

  description = "[TEST] Kubernetes"

  allow_destroy_plan    = false
  auto_apply            = false
  execution_mode        = "local" # FIXME: AWS credentials
  file_triggers_enabled = true
  queue_all_runs        = true
  trigger_prefixes      = ["kubernetes"]
  working_directory     = "kubernetes"

  #vcs_repo {
  #  identifier     =
  #  oauth_token_id =
  #}
}
