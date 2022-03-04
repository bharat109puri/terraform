data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "management_trail" {
  name = "management_trail"

  include_global_service_events = true # to include IAM events
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  s3_bucket_name                = aws_s3_bucket.recrd_cloudtrail.id
  s3_key_prefix                 = "management"

  event_selector {
    read_write_type                  = "All"
    include_management_events        = true
    exclude_management_event_sources = ["kms.amazonaws.com", "rdsdata.amazonaws.com"] # high volume, aws recommendation
  }
}

resource "aws_s3_bucket" "recrd_cloudtrail" {
  acl           = "private"
  bucket        = "recrd-cloudtrail"
  force_destroy = true

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

  # TODO: refactor to HCL
  # At the same time add depends_on to trail resource to depend on policy_document creation to avoid transient issues 
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::recrd-cloudtrail"
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::recrd-cloudtrail/AWSLogs/378942204220/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
  POLICY
}
