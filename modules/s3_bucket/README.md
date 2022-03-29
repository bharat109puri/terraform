<!--
To update docs, run:
  docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.16.0 /terraform-docs
-->
# [WIP] Opinionated S3 Bucket module

This purpose of this module to allow enforcing company policy across all/most buckets.

For the time being this module is highly volatile, changing without notice. Only use it if you're willing to update to a later version and fix/backport functionality you need.

Please keep the module small and give minimal surface to configuration, most of the buckets we use should be alike.

## TODO

This module is pinned down to use `< 4.0.0` AWS provider. This is due to v4 is breaking the S3 bucket interface around the time of setting up the `recrd` AWS account.

Once we're ready to upgrade to v4, this restriction needs to be removed.
Preferably this module is getting versioned (tagged) before we do that.

## Common settings

On average you want encryption at rest (configured) and versioning (currently not configured) everywhere.

You likely want to replicate the buckets to another region/account too (currently not configured).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.70, < 4.0.0 |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_amazon_managed_encryption"></a> [enable\_amazon\_managed\_encryption](#input\_enable\_amazon\_managed\_encryption) | SSE-S3 encryption instead of KMS | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Bucket name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Bucket ARN |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | Region-specific domain name (for CloudFront) |
| <a name="output_name"></a> [name](#output\_name) | Bucket name |
<!-- END_TF_DOCS -->
