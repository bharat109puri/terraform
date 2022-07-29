data "aws_route53_zone" "this" {
  # FIXME: Use real domain
  name = "ad-recrd.com"
}

resource "aws_ses_domain_identity" "recrd_com" {
  # FIXME: Use real domain
  domain = "ad-recrd.com"
}

resource "aws_route53_record" "recrd_com_amazonses_verification_record" {
  zone_id = data.aws_route53_zone.this.zone_id # FIXME: Use bootstrap output
  name    = "_amazonses.${aws_ses_domain_identity.recrd_com.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.recrd_com.verification_token]
}

resource "aws_ses_domain_identity_verification" "recrd_com" {
  domain = aws_ses_domain_identity.recrd_com.id

  depends_on = [
    aws_route53_record.recrd_com_amazonses_verification_record
  ]
}

resource "aws_ses_domain_dkim" "recrd_com" {
  domain = aws_ses_domain_identity.recrd_com.id
}

resource "aws_route53_record" "recrd_com_amazonses_dkim_record" {
  count = 3

  zone_id = data.aws_route53_zone.this.zone_id # FIXME: Use bootstrap output
  name    = "${element(aws_ses_domain_dkim.recrd_com.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.recrd_com.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

data "aws_iam_policy_document" "auth0_ses" {
  statement {
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail",
    ]

    resources = ["*"] # NOTE: Allow sending email to all email addresses
  }
}

resource "aws_iam_user" "auth0_ses" {
  name = "auth0-ses"
}

resource "aws_iam_user_policy" "auth0_ses" {
  name = "ses"
  user = aws_iam_user.auth0_ses.name

  policy = data.aws_iam_policy_document.auth0_ses.json
}

# FIXME: Secret is stored cleartext in state
resource "aws_iam_access_key" "auth0_ses" {
  user = aws_iam_user.auth0_ses.name
}

# NOTE: Sandbox mode requires verified email addresses
resource "aws_ses_email_identity" "mate_at_recrd_com" {
  email = "mate@recrd.com"
}

resource "aws_ses_email_identity" "alexey_at_recrd_com" {
  email = "alexey@recrd.com"
}

resource "aws_ses_email_identity" "roberto_at_recrd_com" {
  email = "roberto@recrd.com"
}

output "id" {
  value = aws_iam_access_key.auth0_ses.id
}

output "secret" {
  value     = aws_iam_access_key.auth0_ses.secret
  sensitive = true
}

# Request production access manually
