module "github_actions_role" {
  source = "git@github.com:RecrdGroup/terraform.git//modules/github_actions_role?ref=master"

  repo_name = "Web-FrontEnd"

  inline_policy     = data.aws_iam_policy_document.deploy_web_frontend.json
  oidc_provider_arn = data.tfe_outputs.bootstrap.values.github_oidc_provider_arn
}
