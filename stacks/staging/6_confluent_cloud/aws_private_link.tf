##########################
#### AWS Private Link ####
##########################


data "tfe_outputs" "bootstrap" {
  organization = "recrd"
  workspace    = join("_", ["${var.env}", "bootstrap"])
}


module "recrd_test_cluster" {
  source = "git@github.com:RecrdGroup/terraform.git//modules/confluentcloud_private_link?ref=master" # TODO: Use tags?

  name = "recrd_test_cluster"

  confluent_kafka_service_name = confluent_private_link_access.aws.private_link_endpoint_service
  bootstrap_endpoint           = confluent_kafka_cluster.this.bootstrap_endpoint

  subnet_cidr_blocks = data.tfe_outputs.bootstrap.values.private_subnet_cidr_blocks
  subnet_ids         = data.tfe_outputs.bootstrap.values.private_subnet_ids
  vpc_id             = data.tfe_outputs.bootstrap.values.vpc_id
}
