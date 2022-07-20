locals {
  eks_addon_ecr = "602401143452.dkr.ecr.eu-west-1.amazonaws.com" # NOTE: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  name          = "${data.tfe_outputs.kubernetes.values.cluster_name}-aws-load-balancer-controller"
}

data "tfe_outputs" "kubernetes" {
  organization = "recrd"
  workspace    = "staging_kubernetes"
}

module "aws_load_balancer_controller_role" {
  source = "../../../../../modules/service_account_role"

  name      = local.name
  namespace = "kube-system"

  inline_policy     = file("policy.json")
  oidc_provider_arn = data.tfe_outputs.kubernetes.values.oidc_provider_arn
}

resource "helm_release" "aws_load_balancer_controller" {
  name      = local.name
  namespace = "kube-system"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.3.3"

  set {
    name  = "image.repository"
    value = "${local.eks_addon_ecr}/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = data.tfe_outputs.kubernetes.values.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = local.name
  }

  # TODO: Enable WAF
  #set {
  #  name  = "enableWafv2"
  #  value = true
  #}

  # TODO: enableShield ?

  depends_on = [
    module.aws_load_balancer_controller_role,
  ]
}
