output "eks_cluster_name" {
  description = "Name of the EKS cluster used for subnet tagging (required for load balancer provisioning)"
  value       = local.eks_cluster_name
}

output "eks_subnet_ids" {
  description = "List of the private EKS subnet IDs"
  value       = module.vpc.intra_subnets
}

output "github_oidc_provider_arn" {
  description = "The ARN of the GitHub OIDC Provider"
  value       = aws_iam_openid_connect_provider.github_actions.arn
}

output "nat_public_ips" {
  description = "List of NAT Gateway IP addresses used (private subnet external IPs)"
  value       = module.vpc.nat_public_ips
}

output "private_subnet_cidr_blocks" {
  description = "List of private subnet cidr_blocks"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "private_subnet_ids" {
  description = "List of the private subnet IDs"
  value       = module.vpc.private_subnets
}

output "recrd_com_public_zone_arn" {
  description = "ARN of the recrd.com public hosted zone"
  value       = aws_route53_zone.recrd_com.arn
}

output "recrd_com_public_zone_id" {
  description = "Zone ID of the recrd.com public hosted zone"
  value       = aws_route53_zone.recrd_com.zone_id
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}
