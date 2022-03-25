locals {
  all_third_parties = flatten(values(var.third_parties)[*].emails)
  everyone          = toset(concat(var.recrd_admins, var.recrd_developers, local.all_third_parties))
}
