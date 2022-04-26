<!--
To update docs, run:
  docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.16.0 /terraform-docs
-->
# Distributed content

This module configures an S3 bucket and distributes it using CloudFront.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.70 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | 3.3.0 |
| <a name="module_origin_bucket"></a> [origin\_bucket](#module\_origin\_bucket) | ../s3_bucket | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aliases"></a> [aliases](#input\_aliases) | Aliases for the CloudFront distribution (must belong to `zone_id` if specified as FQDN) | `list(string)` | `[]` | no |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | List of CIDR blocks allowed to access the CloudFront distribution (WAF-based IP whitelisting) | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Hostname of the CloudFront distribution and suffix of the origin bucket (`recrd-{var.name}`) | `string` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Zone ID to register the CloudFront endpoint | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Name of the CloudFront origin bucket |
| <a name="output_distribution_arn"></a> [distribution\_arn](#output\_distribution\_arn) | ARN of the CloudFront distribution |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | HTTP endpoint of the CloudFront distribution |
<!-- END_TF_DOCS -->
