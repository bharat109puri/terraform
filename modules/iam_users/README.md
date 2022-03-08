<!--
To update docs, run:
  docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.16.0 /terraform-docs
-->
# User management

This module defines the standard way of creating IAM Users, Groups, Roles and the relationship between them.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.70 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws-enforce-mfa"></a> [aws-enforce-mfa](#module\_aws-enforce-mfa) | jeromegamez/enforce-mfa/aws | 2.0.0 |
| <a name="module_iam_assumable_role_ThirdPartyRiltech"></a> [iam\_assumable\_role\_ThirdPartyRiltech](#module\_iam\_assumable\_role\_ThirdPartyRiltech) | terraform-aws-modules/iam/aws//modules/iam-assumable-role | 4.13.2 |
| <a name="module_iam_assumable_role_ThirdPartyRokk"></a> [iam\_assumable\_role\_ThirdPartyRokk](#module\_iam\_assumable\_role\_ThirdPartyRokk) | terraform-aws-modules/iam/aws//modules/iam-assumable-role | 4.13.2 |
| <a name="module_iam_assumable_roles"></a> [iam\_assumable\_roles](#module\_iam\_assumable\_roles) | terraform-aws-modules/iam/aws//modules/iam-assumable-roles | 4.13.2 |
| <a name="module_iam_group_Everyone"></a> [iam\_group\_Everyone](#module\_iam\_group\_Everyone) | terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy | 4.13.2 |
| <a name="module_iam_group_RecrdAdmin"></a> [iam\_group\_RecrdAdmin](#module\_iam\_group\_RecrdAdmin) | terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy | 4.13.2 |
| <a name="module_iam_group_ThridPartyRiltech"></a> [iam\_group\_ThridPartyRiltech](#module\_iam\_group\_ThridPartyRiltech) | terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy | 4.13.2 |
| <a name="module_iam_group_ThridPartyRokk"></a> [iam\_group\_ThridPartyRokk](#module\_iam\_group\_ThridPartyRokk) | terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy | 4.13.2 |
| <a name="module_iam_user_admins"></a> [iam\_user\_admins](#module\_iam\_user\_admins) | terraform-aws-modules/iam/aws//modules/iam-user | 4.13.2 |
| <a name="module_iam_user_developers"></a> [iam\_user\_developers](#module\_iam\_user\_developers) | terraform-aws-modules/iam/aws//modules/iam-user | 4.13.2 |
| <a name="module_iam_user_third_parties"></a> [iam\_user\_third\_parties](#module\_iam\_user\_third\_parties) | terraform-aws-modules/iam/aws//modules/iam-user | 4.13.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_recrd_admins"></a> [recrd\_admins](#input\_recrd\_admins) | List of email addresses used as user name for admins. Specify only `@recrd.com` emails | `list(string)` | n/a | yes |
| <a name="input_recrd_developers"></a> [recrd\_developers](#input\_recrd\_developers) | List of email addresses used as user name for Recrd Developers. Specify only `@recrd.com` emails | `list(string)` | `[]` | no |
| <a name="input_third_parties"></a> [third\_parties](#input\_third\_parties) | Map to define third party access. Stucture: {"third\_party\_name" = ["email\_1"], "email\_2"} | `map(list(string))` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
