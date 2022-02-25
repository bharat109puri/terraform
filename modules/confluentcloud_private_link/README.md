<!--
To update docs, run:
  docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.16.0 /terraform-docs
-->
# Confluent Cloud (Managed Kafka) PrivateLink

After a Confluent Cloud Kafka cluster has been provisioned, manual changes are needed before this module can configure an AWS PrivateLink connection.

Create a `dedicated` cluster and add the AWS account ID on the UI under `Cluster Overview/Networking/Registered AWS Account(s)`
and make note of the `VPC Endpoint service name` value. This is to be passed to this module as `confluent_kafka_service_name`.

The module assumes the Kafka Cluster is in the same region as the VPC.

## TODO

- Use security groups instead subnet CIDRs

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
| <a name="input_bootstrap_endpoint"></a> [bootstrap\_endpoint](#input\_bootstrap\_endpoint) | Kafka cluster bootstrap endpoint (Cluster overview/Cluster settings/General/Identification) | `string` | n/a | yes |
| <a name="input_confluent_kafka_service_name"></a> [confluent\_kafka\_service\_name](#input\_confluent\_kafka\_service\_name) | Confluent Cloud VPC Endpoint service name for the Kafka cluster (Cluster overview/Networking/Private Link Service) | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Kafka cluster name (just an ID for now) | `string` | n/a | yes |
| <a name="input_subnet_cidr_blocks"></a> [subnet\_cidr\_blocks](#input\_subnet\_cidr\_blocks) | TEMP: List CIDR blocks to access the database, this should be replaced by list of security groups | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for the database PrivateLink endpoints | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID for the database PrivateLink endpoints | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
