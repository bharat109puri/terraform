data "tfe_outputs" "kubernetes" {
  organization = "recrd"
  workspace    = join("_", ["${var.env}", "kubernetes"])
}

data "aws_iam_policy_document" "lena" {
  statement {
    actions   = ["sns:Publish"]
    resources = ["*"]
  }
}

module "lena_role" {
  source = "git@github.com:RecrdGroup/terraform.git//modules/service_account_role?ref=master"

  name      = "${var.env}-lena-micro-services" # NOTE: ServiceAccount name to be used in k8s deployment
  namespace = "default"

  inline_policy = data.aws_iam_policy_document.lena.json

  oidc_provider_arn = data.tfe_outputs.kubernetes.values.oidc_provider_arn
}
