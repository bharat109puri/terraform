resource "aws_wafv2_ip_set" "allowed_cidr_blocks" {
  count = length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  name               = "${var.name}-allowed-cidr-blocks"
  description        = "Allowed CIDR blocks for ${var.name} CloudFront distribution"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = var.allowed_cidr_blocks

  provider = aws.us-east-1

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_wafv2_web_acl" "this" {
  count = length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  name        = var.name
  description = "WAF for the ${var.name} CloudFront distribution"
  scope       = "CLOUDFRONT"

  default_action {
    block {}
  }

  rule {
    name     = "allow-cidr-blocks"
    priority = 1

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.allowed_cidr_blocks[0].arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "VPN"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "DefaultAction"
    sampled_requests_enabled   = true
  }

  provider = aws.us-east-1
}
