module "iam_group_admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "4.13.2"

  name = "admin"

  # NOTE: `admin` group members should be able to assume any roles
  assumable_roles = concat(
    [
      module.iam_assumable_roles.admin_iam_role_arn,
      module.iam_assumable_roles.readonly_iam_role_arn,
      module.iam_assumable_role_developer.iam_role_arn,
    ],
    [for role in module.iam_assumable_role_third_party : role.iam_role_arn],
  )
  group_users = keys(module.iam_user_admins)
}

module "iam_group_developer" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "4.13.2"

  name = "developer"

  assumable_roles = [
    module.iam_assumable_role_developer.iam_role_arn,
    module.iam_assumable_roles.readonly_iam_role_arn,
  ]
  group_users = keys(module.iam_user_developers)
}

module "iam_group_everyone" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "4.13.2"

  name            = "everyone"
  assumable_roles = [module.iam_assumable_roles.readonly_iam_role_arn]

  group_users = concat(
    keys(module.iam_user_admins),
    keys(module.iam_user_developers),
    keys(module.iam_user_third_parties),
  )
}

module "iam_group_third_party" {
  for_each = toset(keys(var.third_parties))

  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "4.13.2"

  name            = "third-party-${each.value}"
  assumable_roles = [module.iam_assumable_role_third_party[each.value].iam_role_arn]

  group_users = var.third_parties[each.value].emails
}
