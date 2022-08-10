locals {
  accepter_account_id = element(split(":", data.aws_vpc.accepter.arn), 4)
}
