data "aws_iam_policy_document" "oidc_assume_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:RecrdGroup/${var.repo_name}:ref:refs/*"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.repo_name}-github-actions"
  assume_role_policy = data.aws_iam_policy_document.oidc_assume_policy.json

  inline_policy {
    name   = "${var.repo_name}-policy"
    policy = var.inline_policy
  }
}
