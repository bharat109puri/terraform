<!--
To update docs, run:
  docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.16.0 /terraform-docs
-->
# IAM role assumable by GitHub Actions

The `repo_name` varialbe is going to be used to create the IAM role.

## Example

`RecrdGroup/Web-Frontend` repository is using `repo_name = "Web-Frontend"` and assumes the role in a workflow with the following step.

```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v1
  with:
    role-to-assume: arn:aws:iam::378942204220:role/Web-FrontEnd-github-actions
    aws-region: eu-west-1
```

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.70 |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_inline_policy"></a> [inline\_policy](#input\_inline\_policy) | Inline policy for the role | `string` | n/a | yes |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | GitHub OIDC provider ARN (from bootstrap) | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | GitHub repo name (without `RecrdGroup/` organisation) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the role to be used by GitHub Actions |
<!-- END_TF_DOCS -->
