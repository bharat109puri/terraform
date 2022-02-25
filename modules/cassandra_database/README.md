<!--
To update docs, run:
  docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.16.0 /terraform-docs
-->
# DataStax AstraDB - Serverless Cassandra

The module currently supports provisioning of single-region (but multi-AZ) databases.

The AWS account ID and region is assumed based on the default AWS provider configuration.

## How to use

When you create an `astra_database` resource using this module, the `astra` provider is creating a keyspace to start with.
This keyspace is going to be named as `"default"`. **Do not use** this keyspace for your tables, create your own keyspaces and tables using CQL.

The reason behind this convention is below in the known issues section.

**Do not use** the `astra_keyspace` resource, using CQL is more suitable for now.

## Known issues

**The configured database has unrestricted public access** until it's changed manually through https://astra.datastax.com/ console.
The `astra` provider doesn't support restricting public access and `astra_access_list` seems to be broken.

DataStax support ticket: 00073817

The `astra` provider doesn't support changing the name of the main keyspace (created together with the database).
An attempt to change it results in deletion of the database.

If you remove a keyspace from the Terraform configuration, the `astra` provider is not removing the keyspace only from the Terraform space.
If you try to recreate the same keyspace with terraform again, the creation is going to fail.

## TODO

- Use security groups instead subnet CIDRs
- Design multi-region
  - If we want to have multi-region databases, the interface must change significantly (multi region implies multi VPC)
  - The `astra` provider doesn't support deletion of multi-region databases

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_astra"></a> [astra](#requirement\_astra) | >= 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.70 |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | AstraDB database name | `string` | n/a | yes |
| <a name="input_subnet_cidr_blocks"></a> [subnet\_cidr\_blocks](#input\_subnet\_cidr\_blocks) | TEMP: List CIDR blocks to access the database, this should be replaced by list of security groups | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for the database PrivateLink endpoints | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID for the database PrivateLink endpoints | `string` | n/a | yes |
| <a name="input_zone_ids"></a> [zone\_ids](#input\_zone\_ids) | List of zone IDs to register the PrivateLink endpoints in (Should be IDs of `apps.astra.datastax.com` and `db.astra.datastax.com`) | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_id"></a> [database\_id](#output\_database\_id) | AstraDB database ID |
<!-- END_TF_DOCS -->
