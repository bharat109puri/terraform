resource "aws_s3_bucket" "valossa_results" {
  bucket = "recrd-valossa-results"

  acl = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
      bucket_key_enabled = true
    }
  }
}

resource "aws_s3_bucket_public_access_block" "valossa_results" {
  bucket = aws_s3_bucket.valossa_results.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#TODO: crate indus2 SA and IAM that assums angara-role
# data "aws_iam_policy_document" "indus2" {
#
#   statement {
#     actions = [
#       "s3:GetObject",
#       "s3:PutObject",
#       "s3:DeleteObject"
#     ]
#     resources = ["${aws_s3_bucket.valossa_results.arn}/*"]
#   }
#   statment {
#   actions=[
#
# ]
# resources = ["/*"]
# }
# }
#
# module "indus2_role" {
#   source = "git@github.com:RecrdGroup/terraform.git//modules/service_account_role?ref=master"
#
#   name      = "indus2" # NOTE: ServiceAccount name to be used in k8s deployment
#   namespace = "default"
#
#   inline_policy = data.aws_iam_policy_document.indus2.json
#
#   oidc_provider_arn = data.tfe_outputs.kubernetes.values.oidc_provider_arn
# }
