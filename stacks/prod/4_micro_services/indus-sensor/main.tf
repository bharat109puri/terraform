data "tfe_outputs" "kubernetes" {
  organization = "recrd"
  workspace    = "kubernetes"
}

data "aws_iam_policy_document" "indus-sensor" {
  statement {
    actions   = ["sns:Publish"]
    resources = ["*"]
  }
}

module "indus-sensor_role" {
  source = "git@github.com:RecrdGroup/terraform.git//modules/service_account_role?ref=master"

  name      = "indus-sensor" # NOTE: ServiceAccount name to be used in k8s deployment
  namespace = "default"

  inline_policy = data.aws_iam_policy_document.indus-sensor.json

  oidc_provider_arn = data.tfe_outputs.kubernetes.values.oidc_provider_arn
}
