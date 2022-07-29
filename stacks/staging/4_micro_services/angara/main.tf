data "tfe_outputs" "kubernetes" {
  organization = "recrd"
  workspace    = "kubernetes"
}


data "aws_iam_policy_document" "angara" {
  statement {
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.hls_generator.arn]
  }

  statement {
    actions   = ["mediaconvert:CreateJob", "mediaconvert:DescribeEndpoints"]
    resources = ["*"]
  }

  statement {
    actions   = ["s3:PutObject", "s3:GetObject"]
    resources = ["arn:aws:s3:::recrd-content/*"]
  }

  statement {
    actions   = ["s3:PutObject", "s3:GetObject"]
    resources = ["arn:aws:s3:::recrd-upload/*"]
  }

  statement {
    actions   = ["sqs:*"]
    resources = ["arn:aws:sqs:*:*:hls_process_status"]
  }
}

module "angara_role" {
  source = "git@github.com:RecrdGroup/terraform.git//modules/service_account_role?ref=master"

  name      = "angara" # NOTE: ServiceAccount name to be used in k8s deployment
  namespace = "default"

  inline_policy = data.aws_iam_policy_document.angara.json

  oidc_provider_arn = data.tfe_outputs.kubernetes.values.oidc_provider_arn
}
