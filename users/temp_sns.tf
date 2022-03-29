# NOTE: Allow Alexey to admin SNS until we fix assuming roles for SNS
resource "aws_iam_policy_attachment" "alexey_full_sns" {
  name       = "full-sns"
  users      = ["alexey@recrd.com"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}
