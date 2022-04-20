# recrd-web-frontend deployment
data "aws_iam_policy_document" "deploy_web_frontend" {
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
  }

  statement {
    actions = ["s3:ListBucket"]
    resources = [
      "arn:aws:s3:::recrd-web-frontend",
      "arn:aws:s3:::recrd-web-frontend-staging",
    ]
  }

  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    resources = [
      "arn:aws:s3:::recrd-web-frontend-staging/*",
      "arn:aws:s3:::recrd-web-frontend/*",
    ]
  }
}

resource "aws_iam_policy" "deploy_web_frontend" {
  name   = "deploy-web-frontend"
  policy = data.aws_iam_policy_document.deploy_web_frontend.json
}
