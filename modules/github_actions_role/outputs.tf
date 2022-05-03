output "arn" {
  description = "ARN of the role to be used by GitHub Actions"
  value       = aws_iam_role.this.arn
}
