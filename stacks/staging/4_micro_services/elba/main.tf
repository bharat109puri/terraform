data "tfe_outputs" "kubernetes" {
  organization = "recrd"
  workspace    = join("_", ["${var.env}", "kubernetes"])
}

data "aws_iam_policy_document" "elba" {
  statement {
    actions   = ["sns:Publish"]
    resources = ["*"]
  }
}

module "elba_role" {
  source = "git@github.com:RecrdGroup/terraform.git//modules/service_account_role?ref=master"

  name      = join("-", ["${var.env}", "elba"]) # NOTE: ServiceAccount name to be used in k8s deployment
  namespace = "default"

  inline_policy = data.aws_iam_policy_document.elba.json

  oidc_provider_arn = data.tfe_outputs.kubernetes.values.oidc_provider_arn
}
