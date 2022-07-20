resource "helm_release" "sealed_secrets_controller" {
  name      = "sealed-secrets-controller"
  namespace = "kube-system"

  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  version    = "2.1.4"

  set {
    name  = "fullnameOverride"
    value = "sealed-secrets-controller"
  }
}
