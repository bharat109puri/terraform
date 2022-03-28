module "iam_users" {
  source = "../modules/iam_users"

  recrd_admins = [
    "mate@recrd.com",
    "murali@recrd.com",
  ]

  recrd_developers = [
    "alex@recrd.com",
    "alexey@recrd.com",
    "mate+developer@recrd.com",
  ]

  third_parties = {
    riltech = {
      emails = [
        "mate+riltech@gmail.com",
      ]
      policy_arns = [
        aws_iam_policy.list_buckets.arn
      ]
    }
    rokk = {
      emails      = []
      policy_arns = []
    }
  }
}

data "aws_iam_policy_document" "list_buckets" {
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
  }
}

resource "aws_iam_policy" "list_buckets" {
  name   = "list-buckets"
  policy = data.aws_iam_policy_document.list_buckets.json
}
