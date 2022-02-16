resource "aws_route53_zone" "apps_astradb_datastax_com" {
  name = "apps.astra.datastax.com"

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

# NOTE: Secure bundle is using `db.` domain (`astra_database` outputs are all in `apps.`)
resource "aws_route53_zone" "db_astradb_datastax_com" {
  name = "db.astra.datastax.com"

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}
