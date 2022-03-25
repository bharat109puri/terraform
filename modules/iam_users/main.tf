module "aws-enforce-mfa" {
  source  = "jeromegamez/enforce-mfa/aws"
  version = "2.0.0"

  groups = [module.iam_group_everyone.group_name]

  allow_password_change_without_mfa = true
}
