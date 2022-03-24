output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.eks.cluster_oidc_issuer_url
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_id
}

output "default_aws_auth_map_roles" {
  description = "List of EKS managed role mappings for aws-auth ConfigMap"
  value       = yamldecode(yamldecode(module.eks.aws_auth_configmap_yaml)["data"]["mapRoles"])
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if `enable_irsa = true`"
  value       = module.eks.oidc_provider_arn
}