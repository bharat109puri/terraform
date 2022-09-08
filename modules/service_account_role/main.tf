locals {
  oidc = regex("(?P<prefix>arn:aws:iam::(?P<account_id>[[:digit:]]{12}):oidc-provider/)(?P<oidc>.*)$", var.oidc_provider_arn)["oidc"]
}

data "aws_iam_policy_document" "oidc_assume_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.name}"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "%{if var.environment != ""}${var.environment}-%{endif}${var.name}-role"
  assume_role_policy = data.aws_iam_policy_document.oidc_assume_policy.json

  inline_policy {
    name   = "${var.name}-policy"
    policy = var.inline_policy
  }
}

resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.this.arn
    }

    labels = {
      "app.kubernetes.io/name" = var.name
    }
  }
}
