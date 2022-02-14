locals {
  aws_load_balancer_controller_name = "aws-load-balancer-controller"

  oidc_sub = join(":", [trimprefix(data.tfe_outputs.kubernetes.values.cluster_oidc_issuer_url, "https://"), "sub"])

  eks_addon_ecr = "602401143452.dkr.ecr.eu-west-1.amazonaws.com" # NOTE: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
}

data "tfe_outputs" "kubernetes" {
  organization = "recrd"
  workspace    = "kubernetes"
}

data "aws_iam_policy_document" "oidc_assume_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.tfe_outputs.kubernetes.values.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = local.oidc_sub
      values   = ["system:serviceaccount:kube-system:${local.aws_load_balancer_controller_name}"]
    }
  }
}

resource "aws_iam_role" "aws_load_balancer_controller" {
  name               = "AmazonEKSLoadBalancerControllerRole"
  assume_role_policy = data.aws_iam_policy_document.oidc_assume_policy.json

  inline_policy {
    name = "AWSLoadBalancerControllerIAMPolicy"

    # NOTE: https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.3.1/docs/install/iam_policy.json
    policy = file("iam_policy.json")
  }
}

resource "kubernetes_service_account" "aws_load_balancer_controller" {
  metadata {
    name      = local.aws_load_balancer_controller_name
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.aws_load_balancer_controller.arn
    }

    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name"      = local.aws_load_balancer_controller_name
    }
  }
}

resource "helm_release" "aws_load_balancer_controller" {
  name      = local.aws_load_balancer_controller_name
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
    value = local.aws_load_balancer_controller_name
  }

  # TODO: Enable WAF
  #set {
  #  name  = "enableWafv2"
  #  value = true
  #}

  # TODO: enableShield ?

  # TODO: enableCertManager ?

  depends_on = [
    kubernetes_service_account.aws_load_balancer_controller,
  ]
}
