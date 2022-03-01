data "aws_route53_zone" "recrd_com" {
  name         = local.domain
  private_zone = false
}

module "external_dns_controller_role" {
  source = "../../modules/service_account_role"

  name      = local.external_dns_controller_name
  namespace = "kube-system"

  inline_policy     = templatefile("policies/external_dns_controller.json.tftpl", { hosted_zone_arn = data.aws_route53_zone.recrd_com.arn })
  oidc_provider_arn = data.tfe_outputs.kubernetes.values.oidc_provider_arn
}

resource "helm_release" "external_dns_controller" {
  name      = local.external_dns_controller_name
  namespace = "kube-system"

  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns"
  version    = "1.7.1"

  # NOTE: https://github.com/hashicorp/terraform-provider-helm/issues/92#issuecomment-491876916
  set {
    name  = "domainFilters"
    value = "{${local.domain}}"
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = local.external_dns_controller_name
  }

  depends_on = [
    module.external_dns_controller_role,
  ]
}
