module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "3.3.0"

  domain_name = local.fqdn
  zone_id     = var.zone_id

  subject_alternative_names = var.aliases

  wait_for_validation = true

  providers = {
    aws = aws.us-east-1
  }
}
