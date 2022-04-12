resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "cloudfront_identity_for_s3"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudfront_distribution" "this" {
  aliases = concat([local.fqdn], var.aliases)

  price_class = "PriceClass_100" # FIXME

  default_root_object = "index.html"
  enabled             = true
  is_ipv6_enabled     = true

  origin {
    origin_id   = "origin_bucket"
    domain_name = module.origin_bucket.bucket_regional_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true
    target_origin_id = "origin_bucket"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

    # NOTE: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-response-headers-policies.html
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03" # NOTE: SecurityHeadersPolicy

    # FIXME
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = module.acm.acm_certificate_arn
    ssl_support_method  = "sni-only"

    # NOTE: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/secure-connections-supported-viewer-protocols-ciphers.html
    minimum_protocol_version = "TLSv1.2_2018" # FIXME
  }

  # TODO: Require FULL_CONTROL ACL for `awslogsdelivery`
  #       https://github.com/terraform-providers/terraform-provider-aws/issues/12512
  #       https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
  #logging_config {
  #  bucket          = "recrd-logs"
  #  prefix          = "cloudfront"
  #  include_cookies = false
  #}
}

resource "aws_route53_record" "aliases" {
  for_each = toset(var.aliases)

  zone_id = var.zone_id
  name    = each.value
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "distribution" {
  zone_id = var.zone_id
  name    = var.name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }
}
