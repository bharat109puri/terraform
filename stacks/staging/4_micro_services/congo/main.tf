locals {
  cors = [{
    allowed_headers = ["*"]
    allowed_methods = [
      "GET",
      "POST",
      "PUT",
      "HEAD",
    ]
    allowed_origins = [
      "https://recrd.com",
      "https://www.recrd.com",
      "https://development.recrd.com",
      "https://staging.recrd.com",
      "http://localhost:3000",
      "https://web-frontend-staging.recrd.com",
      "https://web-frontend.recrd.com",
      "https://stg.recrd.com",

    ]
    expose_headers = [
      "Access-Control-Allow-Origin"
    ]
    max_age_seconds = 3000
  }]

}

data "tfe_outputs" "bootstrap" {
  organization = "recrd"
  workspace    = join("_", ["${var.env}", "bootstrap"])
}

data "tfe_outputs" "kubernetes" {
  organization = "recrd"
  workspace    = join("_", ["${var.env}", "kubernetes"])
}


module "content_bucket" {
  source = "git@github.com:RecrdGroup/terraform.git//modules/distributed_content?ref=master"

  name    = join("-", ["${var.env}", "content"])
  zone_id = data.tfe_outputs.bootstrap.values.recrd_com_public_zone_id

  cors_rule = local.cors

  response_headers_policy_id = var.managed_response_headers_policy_id
  smooth_streaming           = true
  price_class                = "PriceClass_All"

  #NOTE: aws.us-east-1 is a provider alias which passes to distributed_content child module and used in waf.tf, versions.tf and certificate.tf
  providers = {
    aws.us-east-1 = aws.us-east-1
  }
}



resource "aws_s3_bucket" "upload" {
  bucket = join("-", ["recrd", "${var.env}", "upload"])

  acl = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        #kms_master_key_id = "" # Use the default for now (aws/s3)
        sse_algorithm = "aws:kms"
      }
      bucket_key_enabled = true
    }
  }

  dynamic "cors_rule" {
    for_each = local.cors == null ? [] : local.cors

    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

resource "aws_s3_bucket_public_access_block" "upload" {
  bucket = aws_s3_bucket.upload.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "congo" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["arn:aws:s3:::${module.content_bucket.bucket_name}/*"]
  }

  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.upload.arn}/*"]
  }
}

module "congo_role" {
  source = "git@github.com:RecrdGroup/terraform.git//modules/service_account_role?ref=master"

  name      = join("-", ["${var.env}", "congo"]) # NOTE: ServiceAccount name to be used in k8s deployment
  namespace = "default"

  inline_policy = data.aws_iam_policy_document.congo.json

  oidc_provider_arn = data.tfe_outputs.kubernetes.values.oidc_provider_arn
}
