output "bucket_name" {
  description = "Name of the CloudFront origin bucket"
  value       = module.origin_bucket.name
}

output "bucket_arn" {
  description = "ARN of origin bucket"
  value       = module.origin_bucket.arn
}

output "distribution_arn" {
  description = "ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.arn
}

output "endpoint" {
  description = "HTTP endpoint of the CloudFront distribution"
  value       = aws_route53_record.distribution.fqdn
}
