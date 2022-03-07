data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "allow_cloudtrail_access" {
  statement {
    sid = "AWSCloudTrailAclCheck"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:GetBucketAcl"]

    resources = ["arn:aws:s3:::${local.cloudtrail_bucket_name}"]
  }

  statement {
    sid = "AWSCloudTrailWrite"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "arn:aws:s3:::${local.cloudtrail_bucket_name}/${local.s3_key_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = ["arn:aws:cloudtrail:${var.region}:${data.aws_caller_identity.current.account_id}:trail/${local.trail_name}"]
    }
  }
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket = local.cloudtrail_bucket_name
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = false
  }
}

resource "aws_s3_bucket_policy" "allow_cloudtrail_access" {
  bucket = aws_s3_bucket.cloudtrail.id
  policy = data.aws_iam_policy_document.allow_cloudtrail_access.json
}

resource "aws_cloudtrail" "management_trail" {
  name = local.trail_name

  include_global_service_events = true # NOTE: To include IAM events
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  s3_key_prefix                 = local.s3_key_prefix

  event_selector {
    read_write_type                  = "All"
    include_management_events        = true
    exclude_management_event_sources = ["kms.amazonaws.com", "rdsdata.amazonaws.com"] # NOTE: High volume, AWS recommendation
  }

  depends_on = [
    aws_s3_bucket_policy.allow_cloudtrail_access
  ]
}
