output "eks_subnet_ids" {
  description = "IDs of the private EKS subnets"
  value       = slice(module.vpc.private_subnets, 3, 6)
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}
