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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_recrd_admins"></a> [recrd\_admins](#input\_recrd\_admins) | List of `admin` email addresses. Specify only `@recrd.com` emails | `list(string)` | n/a | yes |
| <a name="input_recrd_developers"></a> [recrd\_developers](#input\_recrd\_developers) | List of `developer` email addresses. Specify only `@recrd.com` emails | `list(string)` | `[]` | no |
| <a name="input_third_parties"></a> [third\_parties](#input\_third\_parties) | Map to define third party access | <pre>map(object({<br>    emails      = list(string)<br>    policy_arns = list(string)<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_developer_role_arn"></a> [developer\_role\_arn](#output\_developer\_role\_arn) | ARN of `developer` IAM role |
<!-- END_TF_DOCS -->
