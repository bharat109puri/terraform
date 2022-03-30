output "developer_role_arn" {
  description = "ARN of `developer` IAM role"
  value       = module.iam_users.developer_role_arn
}

output "developer_role_name" {
  description = "Name of `developer` IAM role"
  value       = module.iam_users.developer_role_name
}
