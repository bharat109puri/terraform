# NOTE: `astra_database` resource URLs are using this domain
resource "aws_route53_zone" "apps_astradb_datastax_com" {
  name = "stg.apps.astra.datastax.com"

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

# NOTE: AstraDB secure bundle URLs are using this domain
resource "aws_route53_zone" "db_astradb_datastax_com" {
  name = "stg.db.astra.datastax.com"

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  vpc {
    vpc_id = data.tfe_outputs.management.values.vpc_id
  }

}

resource "aws_route53_zone" "recrd_com" {
  name = "stg.recrd.com"
}