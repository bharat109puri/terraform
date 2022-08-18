resource "aws_route53_record" "community_recrd_com_MX" {
  zone_id = aws_route53_zone.recrd_com.zone_id
  name    = "community.recrd.com"
  type    = "MX"
  ttl     = local.ttl
  records = [
    "1 ASPMX.L.GOOGLE.COM.",
    "5 ALT1.ASPMX.L.GOOGLE.COM.",
    "5 ALT2.ASPMX.L.GOOGLE.COM.",
    "10 ALT3.ASPMX.L.GOOGLE.COM.",
    "10 ALT4.ASPMX.L.GOOGLE.COM.",
  ]
}

resource "aws_route53_record" "community_recrd_com_TXT" {
  zone_id = aws_route53_zone.recrd_com.zone_id
  name    = "community.recrd.com"
  type    = "TXT"
  ttl     = local.ttl
  records = [
    "google-site-verification=6O1qtYDKr12JtHKy5-x7gcZCdj5pJxvqA1WxrXvBIEk",
  ]
}
