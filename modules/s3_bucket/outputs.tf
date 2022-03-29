output "arn" {
  description = "Bucket ARN"
  value       = aws_s3_bucket.this.arn
}

output "bucket_regional_domain_name" {
  description = "Region-specific domain name (for CloudFront)"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "name" {
  description = "Bucket name"
  value       = aws_s3_bucket.this.id
}
