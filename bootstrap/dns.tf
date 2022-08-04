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
