data "aws_iam_policy_document" "deploy_web_frontend" {
  statement {
    actions = ["cloudfront:CreateInvalidation"]
    resources = [
      module.frontend.distribution_arn,
      module.frontend_staging.distribution_arn,
    ]
  }

  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
  }

  statement {
    actions = ["s3:ListBucket"]
    resources = [
      "arn:aws:s3:::${module.frontend.bucket_name}",
      "arn:aws:s3:::${module.frontend_staging.bucket_name}",
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
      "arn:aws:s3:::${module.frontend.bucket_name}/*",
      "arn:aws:s3:::${module.frontend_staging.bucket_name}/*",
    ]
  }
}

resource "aws_iam_policy" "deploy_web_frontend" {
  name   = "deploy-web-frontend"
  policy = data.aws_iam_policy_document.deploy_web_frontend.json
}

resource "aws_iam_role_policy_attachment" "developer_deploy_web_frontend" {
  role       = nonsensitive(data.tfe_outputs.users.values.developer_role_name)
  policy_arn = aws_iam_policy.deploy_web_frontend.arn
}
