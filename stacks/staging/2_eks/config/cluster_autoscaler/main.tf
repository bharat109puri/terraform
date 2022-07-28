data "tfe_outputs" "kubernetes" {
  organization = "recrd"
  workspace    = "staging_kubernetes"
}

module "cluster_autoscaler" {
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-cluster-autoscaler.git"

  enabled = true

  cluster_name                     = data.tfe_outputs.kubernetes.values.cluster_name
  cluster_identity_oidc_issuer     = data.tfe_outputs.kubernetes.values.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = data.tfe_outputs.kubernetes.values.oidc_provider_arn
  aws_region                       = var.region
}
