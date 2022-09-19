locals {
  vpc_ids = [
    "${module.vpc.vpc_id}",
    "${nonsensitive(data.tfe_outputs.management.values.vpc_id)}"
  ]
}

# NOTE: `astra_database` resource URLs are using this domain
resource "aws_route53_zone_association" "apps_astradb_datastax_com" {
  for_each = toset(local.vpc_ids)
  zone_id  = data.tfe_outputs.prod_bootstrap.values.apps_astradb_datastax_com_zone_id
  vpc_id   = each.key
}

# NOTE: AstraDB secure bundle URLs are using this domain
resource "aws_route53_zone_association" "db_astradb_datastax_com" {
  for_each = toset(local.vpc_ids)
  zone_id  = data.tfe_outputs.prod_bootstrap.values.db_astradb_datastax_com_zone_id
  vpc_id   = each.key
}

resource "aws_route53_zone" "recrd_com" {
  name = var.recrd_zone
}
