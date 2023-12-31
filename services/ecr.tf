data "aws_iam_policy_document" "manage_ecr_repos" {
  statement {
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    actions   = local.ecr_repo_actions
    resources = [for service in local.services : "arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:repository/${service}"]
  }
}

# TODO: Generate together with workspace?
resource "aws_ecr_repository" "services" {
  for_each = local.services

  name = each.value

  image_tag_mutability = "MUTABLE" # TODO: Do we want mutable tags?

  encryption_configuration {
    encryption_type = "AES256" # TODO: Do we need KMS for replication?
  }
}

resource "aws_iam_policy" "manage_ecr_repos" {
  name   = "manage-ecr-repos"
  policy = data.aws_iam_policy_document.manage_ecr_repos.json
}

resource "aws_iam_role_policy_attachment" "developer_manage_ecr_repos" {
  role       = data.tfe_outputs.users.values.developer_role_name
  policy_arn = aws_iam_policy.manage_ecr_repos.arn
}
