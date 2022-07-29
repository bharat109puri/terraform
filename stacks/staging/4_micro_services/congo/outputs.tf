output "content_bucket_arn" {
  description = "ARN of the content bucket"
  value       = module.content_bucket.bucket_arn #FIXME add bucket_arn output to distributed_content module
}

output "upload_bucket_arn" {
  description = "ARN of the upload bucket"
  value       = aws_s3_bucket.upload.arn
}
