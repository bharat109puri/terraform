module "iam_group_RecrdAdmin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "4.13.2"

  name = "RecrdAdmin"

  # NOTE: RecrdAdmin group members should be able to assume any roles
  assumable_roles = [
    module.iam_assumable_roles.admin_iam_role_arn,
    module.iam_assumable_roles.readonly_iam_role_arn,
    module.iam_assumable_role_RecrdDeveloper.iam_role_arn,
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
