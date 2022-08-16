output "hls_generator_role_arn" {
  description = "ARN of the hls-generator-role for AWS MediaConvert"
  value       = aws_iam_role.hls_generator.arn
}

output "angara_role_arn" {
  description = "ARN of the angara for indus2 service"
  value       = aws_iam_role.hls_generator.arn
}
