resource "aws_route53_record" "influencers_recrd_com_MX" {
  zone_id = aws_route53_zone.recrd_com.zone_id
  name    = "influencers.recrd.com"
  type    = "MX"
  ttl     = local.ttl
  records = [
    "10 inbound-smtp.us-west-2.amazonaws.com"
  ]
}

resource "aws_route53_record" "influencers_recrd_com_TXT" {
  zone_id = aws_route53_zone.recrd_com.zone_id
  name    = "influencers.recrd.com"
  type    = "TXT"
  ttl     = local.ttl
  records = [
    "google-site-verification=Vhu2zsqEYXl2yzgM4Kl2fwoRJI3BVGOEz25-YLUyEOg",
    "v=spf1 include:amazonses.com ~all"
  ]
}

resource "aws_route53_record" "zual5q6owdlg5a5547yuohy7wocezmoj_CNAME" {
  zone_id = aws_route53_zone.recrd_com.zone_id
  name    = "zual5q6owdlg5a5547yuohy7wocezmoj._domainkey.influencers.recrd.com"
  type    = "CNAME"
  ttl     = local.ttl
  records = ["zual5q6owdlg5a5547yuohy7wocezmoj.dkim.amazonses.com"]
}

resource "aws_route53_record" "wewdz3qywm3jgqutxcitexrm3izfpmoz_CNAME" {
  zone_id = aws_route53_zone.recrd_com.zone_id
  name    = "wewdz3qywm3jgqutxcitexrm3izfpmoz._domainkey.influencers.recrd.com"
  type    = "CNAME"
  ttl     = local.ttl
  records = ["wewdz3qywm3jgqutxcitexrm3izfpmoz.dkim.amazonses.com"]
}

resource "aws_route53_record" "_4fk6rwuf3usyqi5jcqocdgyadpg6p6fs_CNAME" {
  zone_id = aws_route53_zone.recrd_com.zone_id
  name    = "4fk6rwuf3usyqi5jcqocdgyadpg6p6fs._domainkey.influencers.recrd.com"
  type    = "CNAME"
  ttl     = local.ttl
  records = ["4fk6rwuf3usyqi5jcqocdgyadpg6p6fs.dkim.amazonses.com"]
}
