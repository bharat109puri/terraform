module "api_recrd_com_certificate" {
  source  = "terraform-aws-modules/acm/aws"
  version = "3.3.0"

  domain_name = "api.recrd.com"
  zone_id     = aws_route53_zone.recrd_com.zone_id

  wait_for_validation = true
}
