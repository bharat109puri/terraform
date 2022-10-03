# NOTE: `astra_database` resource URLs are using this domain
resource "aws_route53_zone" "apps_astradb_datastax_com" {
  name = "apps.astra.datastax.com"

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

# NOTE: AstraDB secure bundle URLs are using this domain
resource "aws_route53_zone" "db_astradb_datastax_com" {
  name = "db.astra.datastax.com"

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

resource "aws_route53_zone" "recrd_com" {
  name = "recrd.com"
}


################################################################################
#########################    AstraDB Staging config    #########################
################################################################################

data "tfe_outputs" "management" {
  organization = "recrd"
  workspace    = "management_network"
}

data "tfe_outputs" "staging_network" {
  organization = "recrd"
  workspace    = "staging_bootstrap"
}

locals {
  vpc_ids = [
    "${nonsensitive(data.tfe_outputs.staging_network.values.vpc_id)}",
    "${nonsensitive(data.tfe_outputs.management.values.vpc_id)}"
  ]
}

# NOTE: `astra_database` resource URLs are using this domain
resource "aws_route53_zone_association" "apps_astradb_datastax_com" {
  for_each = toset(local.vpc_ids)
  zone_id  = aws_route53_zone.apps_astradb_datastax_com.zone_id
  vpc_id   = each.key
}

# NOTE: AstraDB secure bundle URLs are using this domain
resource "aws_route53_zone_association" "db_astradb_datastax_com" {
  for_each = toset(local.vpc_ids)
  zone_id  = aws_route53_zone.db_astradb_datastax_com.zone_id
  vpc_id   = each.key
}
