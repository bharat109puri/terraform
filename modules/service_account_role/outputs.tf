output "role_arn" {
  description = "ARN of created IAM role"
  value       = aws_iam_role.this.arn
}
