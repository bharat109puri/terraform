data "aws_iam_policy_document" "assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["mediaconvert.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "hls_generator" {
  statement {
    sid       = "UploadBucket"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::recrd-upload/*"]
  }

  statement {
    sid       = "DownloadBucket"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::recrd-content/*"]
  }
}

resource "aws_iam_role" "hls_generator" {
  name               = "hls-generator-role"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json

  inline_policy {
    name   = "hls-generator-policy"
    policy = data.aws_iam_policy_document.hls_generator.json
  }
}
