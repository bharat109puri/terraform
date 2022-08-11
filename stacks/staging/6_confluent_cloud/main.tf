resource "confluent_environment" "this" {
  display_name = var.env
}


resource "confluent_network" "aws-private-link" {
  display_name     = "AWS Private Link Network"
  cloud            = "AWS"
  region           = var.region
  connection_types = ["PRIVATELINK"]
  zones            = ["euw1-az1", "euw1-az2", "euw1-az3"]
  environment {
    id = confluent_environment.this.id
  }
}

resource "confluent_private_link_access" "aws" {
  display_name = "AWS Private Link Access"
  aws {
    account = "378942204220"
  }
  environment {
    id = confluent_environment.this.id
  }

  network {
    id = confluent_network.aws-private-link.id
  }
}
##########################
#### AWS Private Link ####
##########################


data "tfe_outputs" "bootstrap" {
  organization = "recrd"
  workspace    = join("_", ["${var.env}", "bootstrap"])
}


resource "aws_vpc_endpoint" "confluent_private_link_access" {
  vpc_id            = data.tfe_outputs.bootstrap.values.vpc_id
  service_name      = confluent_private_link_access.aws.private_link_endpoint_service
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.confluent_private_link_access.id,
  ]

  subnet_ids = [data.tfe_outputs.bootstrap.values.private_subnet_ids]

  tags = {
    Name = join("_", ["${var.env}", "confluent_private_link_access"])
  }
}

data "aws_route53_zone" "internal" {
  name         = "vpc.internal."
  private_zone = true
  vpc_id       = data.tfe_outputs.bootstrap.values.vpc_id
}

resource "aws_route53_record" "ptfe_service" {
  zone_id = data.aws_route53_zone.internal.zone_id
  name    = "ptfe.${data.aws_route53_zone.internal.name}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_vpc_endpoint.ptfe_service.dns_entry[0]["dns_name"]]
}

#########################
#########################

resource "confluent_kafka_cluster" "this" {
  display_name = join("-", ["recrd", "${var.env}", "cluster"])
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  region       = var.region
  dedicated {
    cku = 1
  }
  environment {
    id = confluent_environment.this.id
  }

  network {
    id = confluent_network.aws-private-link.id
  }
}
