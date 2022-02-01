locals {
  recrd_account_id = "378942204220"
}

module "iam_assumable_roles" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "~> 4"

  create_admin_role    = true
  create_readonly_role = true

  trusted_role_arns = [
    "arn:aws:iam::${local.recrd_account_id}:root",
  ]
}
