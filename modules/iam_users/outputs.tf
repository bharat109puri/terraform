output "developer_role_arn" {
  description = "ARN of `developer` IAM role"
  value       = module.iam_assumable_role_developer.iam_role_arn
}
