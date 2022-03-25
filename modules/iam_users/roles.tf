data "aws_caller_identity" "current" {}

# NOTE: Update `module iam_group_RecrdAdmin`'s `assumable_roles` when adding a new role
module "iam_assumable_roles" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "4.13.2"

  create_admin_role    = true
  create_readonly_role = true

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.id}:root",
  ]
}

module "iam_assumable_role_RecrdDeveloper" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.13.2"

  create_role = true
  role_name   = "RecrdDeveloper"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.id}:root",
  ]

  custom_role_policy_arns = [
    # TODO: What permissions does RecrdDeveloper need?
  ]
}

module "iam_assumable_role_ThirdPartyRiltech" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.13.2"

  create_role = true
  role_name   = "ThirdPartyRiltech"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.id}:root",
  ]

  custom_role_policy_arns = [
    # TODO: What permissions does Riltech need?
  ]
}

module "iam_assumable_role_ThirdPartyRokk" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.13.2"

  create_role = true
  role_name   = "ThirdPartyRokk"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.id}:root",
  ]

  custom_role_policy_arns = [
    # TODO: What permissions does Rokk need?
  ]
}
