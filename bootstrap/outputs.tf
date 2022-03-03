output "apps_astradb_datastax_com_zone_id" {
  description = "Zone ID of the apps.astradb.datastax.com private hosted zone"
  value       = aws_route53_zone.apps_astradb_datastax_com.zone_id
}

output "db_astradb_datastax_com_zone_id" {
  description = "Zone ID of the db.astradb.datastax.com private hosted zone"
  value       = aws_route53_zone.db_astradb_datastax_com.zone_id
}

output "eks_secret_encryption_key_arn" {
  description = "ARN of the KMS key used for encrypting Kubernetes Secrets"
  value       = aws_kms_key.eks.arn
}

output "eks_subnet_ids" {
  description = "List of the private EKS subnet IDs"
  value       = module.vpc.intra_subnets
}

output "private_subnet_cidr_blocks" {
  description = "List of private subnet cidr_blocks"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "private_subnet_ids" {
  description = "List of the private subnet IDs"
  value       = module.vpc.private_subnets
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpn_clients_security_group_id" {
  description = "Security group ID associated with the VPN clients"
  value       = aws_security_group.vpn_clients.id
}