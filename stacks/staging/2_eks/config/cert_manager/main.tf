resource "helm_release" "cert_manager_controller" {
  name      = "cert-manager-controller"
  namespace = "kube-system"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.8.0"

  set {
    name  = "installCRDs"
    value = true
  }
}
