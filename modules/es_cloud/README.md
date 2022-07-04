<!--
To update docs, run:
  docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.16.0 /terraform-docs
-->
# Elastic Cloud - Managed Elasticsearch

This module requires a shared (one per VPC) VPC endpoint which can be created by the `vpc_endpoint` submodule.

## Known issues

- As auto-scaling is enabled changes to `topology {}` blocks are ignored by Terraform to mitigate a perpetual change between the code and reality
  - The configured topologies will be used only on creation of a new deployment
  - If topologies need to be configured differently the code needs to be changed and the same changes need to be made manually on existing deployments
  - Allowing Terraform to update `topology {}` blocks while auto-scaling is enabled would potentially cause a large-scale change in the deployment with associated performance loss during the change
- When the `elastic/ec` Terraform provider is planning to make a change which would temporarily add >= 6 nodes to the deployment it fails because we don't have `master` nodes defined in `topology {}` blocks

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.70.0 |
| <a name="requirement_ec"></a> [ec](#requirement\_ec) | >= 0.4.0 |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_elastic_version"></a> [elastic\_version](#input\_elastic\_version) | Elasticsearch version | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Elastic Cloud deployment name | `string` | n/a | yes |
| <a name="input_vpc_endpoint_id"></a> [vpc\_endpoint\_id](#input\_vpc\_endpoint\_id) | Elastic VPC endpoint ID (output from `vpc_endpoint` submodule) | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
