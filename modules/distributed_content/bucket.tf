module "origin_bucket" {
  source = "../s3_bucket"

  name = "recrd-${var.name}"

  # NOTE: KMS encryption would require Lambda@Edge to decrypt objects
  #       https://aws.amazon.com/blogs/networking-and-content-delivery/serving-sse-kms-encrypted-content-from-s3-using-cloudfront/
  enable_amazon_managed_encryption = true

  cors_rule = var.cors_rule
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.origin_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.origin_bucket.name
  policy = data.aws_iam_policy_document.bucket_policy.json
}
