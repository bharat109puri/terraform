locals {
  members = toset([
    "gabor@recrd.com",
    "mate@recrd.com",
  ])
}

data "tfe_team" "owners" {
  name         = "owners"
  organization = tfe_organization.recrd.name
}

resource "tfe_organization" "recrd" {
  name  = "recrd"
  email = "mate@recrd.com" # FIXME

  collaborator_auth_policy = "two_factor_mandatory"
}

resource "tfe_organization_membership" "recrd" {
  for_each = local.members

  organization = tfe_organization.recrd.name
  email        = each.value
}

resource "tfe_team_organization_member" "owners" {
  # NOTE: In Terraform Cloud Free everyone is owner
  for_each = local.members

  team_id                    = data.tfe_team.owners.id
  organization_membership_id = tfe_organization_membership.recrd[each.value].id

  lifecycle {
    prevent_destroy = true
  }
}
