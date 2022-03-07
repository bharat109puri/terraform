data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "allow_cloudtrail_access" {

  statement {
    sid = "AWSCloudTrailAclCheck20150319"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:GetBucketAcl"]

    resources = ["arn:aws:s3:::${local.cloudtrail_bucket_name}"]
  }

  statement {
    sid = "AWSCloudTrailWrite20150319"

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

      values = [
        "arn:aws:cloudtrail:eu-west-1:${data.aws_caller_identity.current.account_id}:trail/management_trail",
      ]
    }
  }
}

resource "aws_cloudtrail" "management_trail" {
  name = "management_trail"

  include_global_service_events = true # to include IAM events
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  s3_bucket_name                = aws_s3_bucket.recrd_cloudtrail.id
  s3_key_prefix                 = local.s3_key_prefix

  event_selector {
    read_write_type                  = "All"
    include_management_events        = true
    exclude_management_event_sources = ["kms.amazonaws.com", "rdsdata.amazonaws.com"] # high volume, aws recommendation
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.recrd_cloudtrail.id
  policy = data.aws_iam_policy_document.allow_cloudtrail_access.json
}

resource "aws_s3_bucket" "recrd_cloudtrail" {
  acl    = "private"
  bucket = local.cloudtrail_bucket_name

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

