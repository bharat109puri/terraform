data "tfe_outputs" "bootstrap" {
  organization = "recrd"
  workspace    = "staging_bootstrap"
}

module "cassandra_database" {
  source = "git@github.com:RecrdGroup/terraform.git//modules/cassandra_database?ref=master"

  name = var.environment

  subnet_cidr_blocks = data.tfe_outputs.bootstrap.values.private_subnet_cidr_blocks
  subnet_ids         = data.tfe_outputs.bootstrap.values.private_subnet_ids
  vpc_id             = data.tfe_outputs.bootstrap.values.vpc_id

  zone_ids = [
    nonsensitive(data.tfe_outputs.bootstrap.values.apps_astradb_datastax_com_zone_id),
    nonsensitive(data.tfe_outputs.bootstrap.values.db_astradb_datastax_com_zone_id),
  ]
}

resource "astra_role" "app_data_reader" {
  role_name   = "${var.environment}_app_data_reader"
  description = "${var.environment}_app_data_reader"
  effect      = "allow"

  resources = [
    "drn:astra:org:${module.cassandra_database.organization_id}",
    "drn:astra:org:${module.cassandra_database.organization_id}:db:${module.cassandra_database.database_id}",
    "drn:astra:org:${module.cassandra_database.organization_id}:db:${module.cassandra_database.database_id}:keyspace:system_schema:table:*",
    "drn:astra:org:${module.cassandra_database.organization_id}:db:${module.cassandra_database.database_id}:keyspace:system:table:*",
    "drn:astra:org:${module.cassandra_database.organization_id}:db:${module.cassandra_database.database_id}:keyspace:system_virtual_schema:table:*",
    "drn:astra:org:${module.cassandra_database.organization_id}:db:${module.cassandra_database.database_id}:keyspace:app_data",        # FIXME: `app_data` keyspace is managed outside of Terraform
    "drn:astra:org:${module.cassandra_database.organization_id}:db:${module.cassandra_database.database_id}:keyspace:app_data:table:*" # FIXME: `app_data` keyspace is managed outside of Terraform
  ]
  policy = [
    "db-cql",
    "db-table-select",
  ]
}

# FIXME: Secret is stored cleartext in state
resource "astra_token" "congo" {
  roles = [astra_role.app_data_reader.id]
}

# FIXME: Secret is stored cleartext in state
resource "astra_token" "elba" {
  roles = [astra_role.app_data_reader.id]
}

# FIXME: Secret is stored cleartext in state
resource "astra_token" "nile" {
  roles = [astra_role.app_data_reader.id]
}
