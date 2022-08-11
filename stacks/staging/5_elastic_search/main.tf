module "elastic_vpc_endpoint" {
  source = "git@github.com:RecrdGroup/terraform.git//modules/elastic_cloud/vpc_endpoint?ref=master"

  allowed_security_group_ids = [
    data.tfe_outputs.bootstrap.values.eks_security_group_id,
  ]
  subnet_ids = data.tfe_outputs.bootstrap.values.private_subnet_ids
  vpc_id     = data.tfe_outputs.bootstrap.values.vpc_id
}

module "elastic_deployment" {
  source          = "git@github.com:RecrdGroup/terraform.git//modules/es_cloud?ref=master"
  name            = var.elastic_name
  elastic_version = var.elastic_version
  vpc_endpoint_id = module.elastic_vpc_endpoint.id
  topology        = var.topology
}
