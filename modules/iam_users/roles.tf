# NOTE: Update `module.iam_group_admin`'s `assumable_roles` when adding a new role
data "aws_caller_identity" "current" {}

module "iam_assumable_roles" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "4.13.2"

  create_admin_role    = true
  create_readonly_role = true

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.id}:root",
  ]
}

module "iam_assumable_role_developer" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.13.2"

  create_role = true
  role_name   = "developer"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.id}:root",
  ]

  attach_readonly_policy = true

  custom_role_policy_arns = [
    aws_iam_policy.deploy_web_frontend.arn,
  ]
}

module "iam_assumable_role_third_party" {
  for_each = toset(keys(var.third_parties))

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.13.2"

  create_role = true
  role_name   = "third-party-${each.value}"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.id}:root",
  ]

  custom_role_policy_arns = var.third_parties[each.value].policy_arns
}
