output "bucket_name" {
  description = "Name of the CloudFront origin bucket"
  value       = module.origin_bucket.name
}

output "distribution_arn" {
  description = "ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.arn
}

output "endpoint" {
  description = "HTTP endpoint of the CloudFront distribution"
  value       = aws_route53_record.distribution.fqdn
}
