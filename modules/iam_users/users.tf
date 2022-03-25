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
