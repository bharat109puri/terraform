data "aws_iam_policy_document" "manage_single_ecr_repo" {
  for_each = local.services

  statement {
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    actions   = local.ecr_repo_actions
    resources = ["arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:repository/${each.value}"]
  }
}

module "publish_docker_image" {
  for_each = local.services

  source = "../../../modules/github_actions_role"

  repo_name   = each.value
  role_suffix = "${var.environment}-publish-docker-image"

  inline_policy     = data.aws_iam_policy_document.manage_single_ecr_repo[each.value].json
  oidc_provider_arn = data.tfe_outputs.bootstrap.values.github_oidc_provider_arn
}