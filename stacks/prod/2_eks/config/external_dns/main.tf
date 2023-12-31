locals {
  domain = "recrd.com"
  name   = "external-dns-controller"
}

data "tfe_outputs" "bootstrap" {
  organization = "recrd"
  workspace    = "bootstrap"
}

data "tfe_outputs" "kubernetes" {
  organization = "recrd"
  workspace    = "kubernetes"
}

module "external_dns_controller_role" {
  source = "git@github.com:RecrdGroup/terraform.git//modules/service_account_role?ref=master"

  name      = local.name
  namespace = "kube-system"

  inline_policy     = templatefile("policy.json.tftpl", { hosted_zone_arn = nonsensitive(data.tfe_outputs.bootstrap.values.recrd_com_public_zone_arn) })
  oidc_provider_arn = data.tfe_outputs.kubernetes.values.oidc_provider_arn
}

resource "helm_release" "external_dns_controller" {
  name      = local.name
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
    name  = "policy"
    value = "sync"
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = local.name
  }

  depends_on = [
    module.external_dns_controller_role,
  ]
}
