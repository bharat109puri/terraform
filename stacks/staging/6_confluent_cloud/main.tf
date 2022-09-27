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
    account = var.account
  }
  environment {
    id = confluent_environment.this.id
  }

  network {
    id = confluent_network.aws-private-link.id
  }
}

resource "confluent_kafka_cluster" "this" {
  display_name = "recrd-%{if var.env != ""}${var.env}-%{endif}cluster"
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
  depends_on = [
    confluent_environment.this,
    confluent_network.aws-private-link
  ]
}
