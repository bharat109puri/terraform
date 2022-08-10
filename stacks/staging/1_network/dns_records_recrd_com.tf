# locals {
#   ttl                = "300"
#   cloudfront_zone_id = "Z2FDTNDATAQYW2" # NOTE: This is the same string globally for all CloudFront aliases

#   recrd_com_alias_a_records = {
#     "beta-api.recrd.com" = {
#       alias_name    = "d-zu4mvhzhfk.execute-api.eu-west-2.amazonaws.com.",
#       alias_zone_id = "ZJ5UAJN8Y3Z2Q",
#     },
#     "dev-api.recrd.com" = {
#       alias_name    = "d-pjamjl3u35.execute-api.eu-west-2.amazonaws.com.",
#       alias_zone_id = "ZJ5UAJN8Y3Z2Q",
#     },
#     "media.recrd.com" = {
#       alias_name    = "d2frhyzbkg7yr0.cloudfront.net.",
#       alias_zone_id = local.cloudfront_zone_id,
#     },
#   }

#   recrd_com_alias_aaaa_records = {
#     "beta-api.recrd.com" = {
#       alias_name    = "d-zu4mvhzhfk.execute-api.eu-west-2.amazonaws.com.",
#       alias_zone_id = "ZJ5UAJN8Y3Z2Q",
#     },
#     "dev-api.recrd.com" = {
#       alias_name    = "d-pjamjl3u35.execute-api.eu-west-2.amazonaws.com.",
#       alias_zone_id = "ZJ5UAJN8Y3Z2Q",
#     },
#   }
# }

# resource "aws_route53_record" "recrd_com_alias_a_records" {
#   for_each = local.recrd_com_alias_a_records

#   zone_id = aws_route53_zone.recrd_com.zone_id
#   name    = each.key
#   type    = "A"

#   alias {
#     name                   = each.value["alias_name"]
#     zone_id                = each.value["alias_zone_id"]
#     evaluate_target_health = false # NOTE: It's required but has no effect (https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-values-alias.html#rrsets-values-alias-evaluate-target-health)
#   }
# }

# resource "aws_route53_record" "recrd_com_alias_aaaa_records" {
#   for_each = local.recrd_com_alias_aaaa_records

#   zone_id = aws_route53_zone.recrd_com.zone_id
#   name    = each.key
#   type    = "AAAA"

#   alias {
#     name                   = each.value["alias_name"]
#     zone_id                = each.value["alias_zone_id"]
#     evaluate_target_health = false # NOTE: It's required but has no effect (https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-values-alias.html#rrsets-values-alias-evaluate-target-health)
#   }
# }

# resource "aws_route53_record" "_amazonses_TXT" {
#   zone_id = aws_route53_zone.recrd_com.zone_id
#   name    = "_amazonses.recrd.com"
#   type    = "TXT"
#   ttl     = local.ttl
#   records = ["dpSBmtTiAFJgKn9hSWwM1HM2TBBRXGrtjbQX0Gu8kDk="]
# }

# resource "aws_route53_record" "_d94d424ca9108658471c32421f7126aa_CNAME" {
#   zone_id = aws_route53_zone.recrd_com.zone_id
#   name    = "_d94d424ca9108658471c32421f7126aa.recrd.com"
#   type    = "CNAME"
#   ttl     = local.ttl
#   records = ["_3ec01addb406fcb48efe9f94f93f98cd.nfyddsqlcy.acm-validations.aws."]
# }

# resource "aws_route53_record" "dev_CNAME" {
#   zone_id = aws_route53_zone.recrd_com.zone_id
#   name    = "dev.recrd.com"
#   type    = "CNAME"
#   ttl     = local.ttl
#   records = ["d2k5cbe38pgrwi.cloudfront.net."]
# }

# resource "aws_route53_record" "_MX" {
#   zone_id = aws_route53_zone.recrd_com.zone_id
#   name    = "recrd.com"
#   type    = "MX"
#   ttl     = local.ttl
#   records = [
#     "1 ASPMX.L.GOOGLE.COM.",
#     "5 ALT1.ASPMX.L.GOOGLE.COM.",
#     "5 ALT2.ASPMX.L.GOOGLE.COM.",
#     "10 ALT3.ASPMX.L.GOOGLE.COM.",
#     "10 ALT4.ASPMX.L.GOOGLE.COM.",
#     "15 ee4cttrrajvzgo7ikk3z4scj2e6wvtufxoyv7p3wvkkt7ybtumyq.mx-verification.google.com.",
#   ]
# }

# resource "aws_route53_record" "mail_MX" {
#   zone_id = aws_route53_zone.recrd_com.zone_id
#   name    = "mail.recrd.com"
#   type    = "MX"
#   ttl     = local.ttl
#   records = ["10 feedback-smtp.eu-west-2.amazonses.com"]
# }

# resource "aws_route53_record" "mail_TXT" {
#   zone_id = aws_route53_zone.recrd_com.zone_id
#   name    = "mail.recrd.com"
#   type    = "TXT"
#   ttl     = local.ttl
#   records = ["v=spf1 include:amazonses.com ~all"]
# }

# resource "aws_route53_record" "recrd_api_TXT" {
#   zone_id = aws_route53_zone.recrd_com.zone_id
#   name    = "recrd-api.recrd.com"
#   type    = "TXT"
#   ttl     = local.ttl
#   records = ["amazonses:1q0R6e91h9suTQnt+u9kteRoGjguY20/c4z7Sjtvhgo="]
# }
