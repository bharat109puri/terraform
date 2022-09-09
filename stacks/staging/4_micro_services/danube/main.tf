data "tfe_outputs" "kubernetes" {
  organization = "recrd"
  workspace    = "%{if var.env != ""}${var.env}_%{endif}kubernetes"
}

data "aws_iam_policy_document" "danube" {
  statement {
    actions   = ["sns:Publish"]
    resources = ["*"]
  }
}

module "danube_role" {
  source = "git@github.com:RecrdGroup/terraform.git//modules/service_account_role?ref=master"

  name        = "danube" # NOTE: ServiceAccount name to be used in k8s deployment
  environment = var.env
  namespace   = "default"

  inline_policy = data.aws_iam_policy_document.danube.json

  oidc_provider_arn = data.tfe_outputs.kubernetes.values.oidc_provider_arn
}
