resource "aws_s3_bucket" "this" {
  bucket = var.name

  acl = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        #kms_master_key_id = "" # In case of KMS, use the default for now (aws/s3)
        sse_algorithm = var.enable_amazon_managed_encryption ? "AES256" : "aws:kms"
      }
      bucket_key_enabled = !var.enable_amazon_managed_encryption
    }
  }

  dynamic "cors_rule" {
    for_each = toset(length(var.cors_rule) > 0 ? [var.cors_rule] : [])

    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
