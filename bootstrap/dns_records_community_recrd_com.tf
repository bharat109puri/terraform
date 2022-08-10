resource "aws_route53_record" "_2l7bbnxyf2ee_CNAME" {
  zone_id = aws_route53_zone.community_recrd_com.zone_id
  name    = "2l7bbnxyf2ee.community.recrd.com.community.recrd.com"
  type    = "CNAME"
  ttl     = local.ttl
  records = ["gv-ffyjciri2mp6ri.dv.googlehosted.com"]
}

resource "aws_route53_record" "_7mabyzrev6dgwagpayuaaqtpnhenkg4p_CNAME" {
  zone_id = aws_route53_zone.community_recrd_com.zone_id
  name    = "7mabyzrev6dgwagpayuaaqtpnhenkg4p._domainkey.community.recrd.com"
  type    = "CNAME"
  ttl     = local.ttl
  records = ["7mabyzrev6dgwagpayuaaqtpnhenkg4p.dkim.amazonses.com"]
}

resource "aws_route53_record" "kn2zo4mtftthik5cz2h5ncrcllabslic_CNAME" {
  zone_id = aws_route53_zone.community_recrd_com.zone_id
  name    = "kn2zo4mtftthik5cz2h5ncrcllabslic._domainkey.community.recrd.com"
  type    = "CNAME"
  ttl     = local.ttl
  records = ["kn2zo4mtftthik5cz2h5ncrcllabslic.dkim.amazonses.com"]
}

resource "aws_route53_record" "tc5oqtf6elklp2n2c277jgotwrxv2vcu_CNAME" {
  zone_id = aws_route53_zone.community_recrd_com.zone_id
  name    = "tc5oqtf6elklp2n2c277jgotwrxv2vcu._domainkey.community.recrd.com"
  type    = "CNAME"
  ttl     = local.ttl
  records = ["tc5oqtf6elklp2n2c277jgotwrxv2vcu.dkim.amazonses.com"]
}

resource "aws_route53_record" "community_recrd_com_MX" {
  zone_id = aws_route53_zone.community_recrd_com.zone_id
  name    = "community.recrd.com"
  type    = "MX"
  ttl     = local.ttl
  records = ["10 inbound-smtp.us-west-2.amazonaws.com"]
}

resource "aws_route53_record" "community_recrd_com_TXT" {
  zone_id = aws_route53_zone.community_recrd_com.zone_id
  name    = "community.recrd.com"
  type    = "TXT"
  ttl     = local.ttl
  records = [
    "google-site-verification=xnMhIb80CjXskNXrNP3OZ4A8UjrGlNR-lDZMn9tYJ58",
    "v=spf1 include:amazonses.com ~all"
  ]
}
