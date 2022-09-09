data "tfe_outputs" "kubernetes" {
  organization = "recrd"
  workspace    = "%{if var.env != ""}${var.env}_%{endif}kubernetes"
}

# data "tfe_outputs" "indus2" {
#   organization = "recrd"
#   workspace    = "%{if var.env != ""}${var.env}_%{endif}indus2"
# }

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
    resources = ["${data.tfe_outputs.congo.values.content_bucket_arn}/*"]
  }

  statement {
    actions   = ["s3:PutObject", "s3:GetObject"]
    resources = ["${data.tfe_outputs.congo.values.upload_bucket_arn}/*"]
  }

  statement {
    actions   = ["sqs:*"]
    resources = ["arn:aws:sqs:*:*:hls_process_status"]
  }

  # statement {
  #   actions = [
  #     "s3:GetObject",
  #     "s3:PutObject",
  #     "s3:DeleteObject"
  #   ]
  #   resources = ["${data.tfe_outputs.indus2.values.valossa_results_arn}/*"]
  # }

}

module "angara_role" {
  source = "git@github.com:RecrdGroup/terraform.git//modules/service_account_role?ref=master"

  name        = "angara" # NOTE: ServiceAccount name to be used in k8s deployment
  environment = var.env
  namespace   = "default"

  inline_policy = data.aws_iam_policy_document.angara.json

  oidc_provider_arn = data.tfe_outputs.kubernetes.values.oidc_provider_arn
}
