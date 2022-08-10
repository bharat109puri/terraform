output "hls_generator_role_arn" {
  description = "ARN of the hls-generator-role for AWS MediaConvert"
  value       = aws_iam_role.hls_generator.arn
}
