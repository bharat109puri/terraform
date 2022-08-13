##########################
#### AWS Private Link ####
##########################


data "tfe_outputs" "bootstrap" {
  organization = "recrd"
  workspace    = join("_", ["${var.env}", "bootstrap"])
}


module "confluent_cluster_private_link" {
  source = "git@github.com:RecrdGroup/terraform.git//modules/confluentcloud_private_link?ref=master" # TODO: Use tags?

  name = join("-", ["recrd", "${var.env}", "cluster"])

  confluent_kafka_service_name = confluent_network.aws-private-link.aws[0].private_link_endpoint_service
  bootstrap_endpoint           = confluent_kafka_cluster.this.bootstrap_endpoint

  subnet_cidr_blocks = data.tfe_outputs.bootstrap.values.private_subnet_cidr_blocks
  subnet_ids         = data.tfe_outputs.bootstrap.values.private_subnet_ids
  vpc_id             = data.tfe_outputs.bootstrap.values.vpc_id

  depends_on = [confluent_network.aws-private-link, confluent_kafka_cluster.this]
}
