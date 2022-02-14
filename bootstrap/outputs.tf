output "eks_subnet_ids" {
  description = "IDs of the private EKS subnets"
  value       = module.vpc.intra_subnets
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnets
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}
