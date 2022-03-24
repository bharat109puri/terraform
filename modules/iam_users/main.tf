data "aws_caller_identity" "current" {}

module "iam_user_admins" {
  for_each = toset(var.recrd_admins)

  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "4.13.2"

  name = each.key

  create_iam_user_login_profile = false
  create_iam_access_key         = false
  force_destroy                 = true
  password_reset_required       = true
}

module "iam_user_developers" {
  for_each = toset(var.recrd_developers)

  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "4.13.2"

  name = each.key

  create_iam_user_login_profile = false
  create_iam_access_key         = false
  force_destroy                 = true
  password_reset_required       = true
}

module "iam_user_third_parties" {
  for_each = toset(local.all_third_parties)

  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "4.13.2"

  name = each.key

  create_iam_user_login_profile = false
  create_iam_access_key         = false
  force_destroy                 = true
  password_reset_required       = true
}

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

module "iam_group_RecrdAdmin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "4.13.2"

  name = "RecrdAdmin"

  # NOTE: RecrdAdmin group members should be able to assume any roles
  assumable_roles = [
    module.iam_assumable_roles.admin_iam_role_arn,
    module.iam_assumable_roles.readonly_iam_role_arn,
    module.iam_assumable_role_ThirdPartyRiltech.iam_role_arn,
    module.iam_assumable_role_ThirdPartyRokk.iam_role_arn,
  ]
  group_users = keys(module.iam_user_admins)
}

module "iam_group_RecrdDeveloper" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "4.13.2"

  name = "RecrdDeveloper"

  assumable_roles = [
    module.iam_assumable_role_RecrdDeveloper.iam_role_arn,
  ]
  group_users = keys(module.iam_user_developers)
}

module "iam_group_Everyone" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "4.13.2"

  name            = "Everyone"
  assumable_roles = [module.iam_assumable_roles.readonly_iam_role_arn]

  group_users = concat(
    keys(module.iam_user_admins),
    keys(module.iam_user_developers),
    keys(module.iam_user_third_parties),
  )
}

module "iam_group_ThridPartyRiltech" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "4.13.2"

  name            = "ThridPartyRiltech"
  assumable_roles = [module.iam_assumable_role_ThirdPartyRiltech.iam_role_arn]

  group_users = var.third_parties["riltech"]
}

module "iam_group_ThridPartyRokk" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "4.13.2"

  name            = "ThridPartyRokk"
  assumable_roles = [module.iam_assumable_role_ThirdPartyRokk.iam_role_arn]

  group_users = var.third_parties["rokk"]
}

module "aws-enforce-mfa" {
  source  = "jeromegamez/enforce-mfa/aws"
  version = "2.0.0"

  groups = [module.iam_group_Everyone.group_name]

  allow_password_change_without_mfa = true
}