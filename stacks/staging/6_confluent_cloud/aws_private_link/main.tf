##########################
#### AWS Private Link ####
##########################


data "tfe_outputs" "bootstrap" {
  organization = "recrd"
  workspace    = "%{if var.env != ""}${var.env}_%{endif}bootstrap"
}

data "tfe_outputs" "confluent" {
  organization = "recrd"
  workspace    = "%{if var.env != ""}${var.env}_%{endif}confluent_cloud"
}


module "confluent_cluster_private_link" {
  source = "git@github.com:RecrdGroup/terraform.git//modules/confluentcloud_private_link?ref=master" # TODO: Use tags?

  name = "recrd-%{if var.env != ""}${var.env}-%{endif}cluster"

  confluent_kafka_service_name = data.tfe_outputs.confluent.values.confluent_kafka_service_name
  bootstrap_endpoint           = data.tfe_outputs.confluent.values.bootstrap_endpoint

  subnet_cidr_blocks = data.tfe_outputs.bootstrap.values.private_subnet_cidr_blocks
  subnet_ids         = data.tfe_outputs.bootstrap.values.private_subnet_ids
  vpc_id             = data.tfe_outputs.bootstrap.values.vpc_id

}
