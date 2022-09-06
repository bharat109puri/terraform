output "valossa_results_arn" {
  description = "ARN of velosa result s3 bucket"
  value       = aws_s3_bucket.valossa_results.arn
}

output "thehive_results_arn" {
  description = "ARN of thehive result s3 bucket"
  value       = aws_s3_bucket.thehive_results.arn
}
