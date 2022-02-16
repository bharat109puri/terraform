data "tfe_outputs" "bootstrap" {
  organization = "recrd"
  workspace    = "bootstrap"
}

module "test" {
  source = "../../modules/cassandra_database"

  name = "recrd-test"

  subnet_cidr_blocks = data.tfe_outputs.bootstrap.values.private_subnet_cidr_blocks
  subnet_ids         = data.tfe_outputs.bootstrap.values.private_subnet_ids
  vpc_id             = data.tfe_outputs.bootstrap.values.vpc_id

  zone_ids = [
    nonsensitive(data.tfe_outputs.bootstrap.values.apps_astradb_datastax_com_zone_id),
    nonsensitive(data.tfe_outputs.bootstrap.values.db_astradb_datastax_com_zone_id),
  ]
}
