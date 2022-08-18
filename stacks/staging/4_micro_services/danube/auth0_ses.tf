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
  name = join("-", ["${var.env}", "auth0-ses"])
}

resource "aws_iam_user_policy" "auth0_ses" {
  name = join("-", ["${var.env}", "ses"])
  user = aws_iam_user.auth0_ses.name

  policy = data.aws_iam_policy_document.auth0_ses.json
}

# FIXME: Secret is stored cleartext in state
resource "aws_iam_access_key" "auth0_ses" {
  user = aws_iam_user.auth0_ses.name
}
