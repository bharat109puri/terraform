data "aws_iam_policy_document" "assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["mediaconvert.amazonaws.com"]
    }
  }
}

data "tfe_outputs" "congo" {
  organization = "recrd"
  workspace    = join("_", ["${var.env}", "congo"])
}

data "aws_iam_policy_document" "hls_generator" {
  statement {
    sid       = "UploadBucket"
    actions   = ["s3:GetObject"]
    resources = ["${data.tfe_outputs.congo.values.upload_bucket_arn}/*"]
  }

  statement {
    sid       = "DownloadBucket"
    actions   = ["s3:PutObject"]
    resources = ["${data.tfe_outputs.congo.values.content_bucket_arn}/*"]
  }
}

resource "aws_iam_role" "hls_generator" {
  name               = join("-", ["${var.env}", "hls-generator-role"])
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json

  inline_policy {
    name   = join("-", ["${var.env}", "hls-generator-policy"])
    policy = data.aws_iam_policy_document.hls_generator.json
  }
}
