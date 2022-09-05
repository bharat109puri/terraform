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
