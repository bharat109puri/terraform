# Terraform Cloud configuration

## Remove users

`tfe_team_organization_member` resources have `prevent_destroy = true` attribute set.

To remove a user from the organization follow these steps:
1. Remove the user from `main.tf`.
2. Plan and receive the `Error: Instance cannot be destroyed` message on the right user.
3. Remove the user manually from [Terraform Cloud users](https://app.terraform.io/app/recrd/settings/users).
4. Run `terraform apply -refresh-only` to persist change into the Terraform state.
