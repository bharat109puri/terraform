data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "astra_database" "this" {
  name           = var.name
  keyspace       = "default"
  cloud_provider = "aws"
  regions        = [data.aws_region.current.name]
}

resource "astra_private_link" "this" {
  allowed_principals = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  database_id        = astra_database.this.id
  datacenter_id      = "${astra_database.this.id}-1"
}

resource "aws_security_group" "database_access" {
  name   = "${var.name}-astradb-access"
  vpc_id = var.vpc_id

  # NOTE: https://docs.datastax.com/en/astra/docs/datastax-astra-faq.html#_which_ports_are_used_by_serverless_databases
  # TODO: Use security groups instead of network?
  ingress {
    description = "REST, GraphQL and Astra DB Health dashboard"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.subnet_cidr_blocks
  }

  ingress {
    description = "CQL"
    from_port   = 29042
    to_port     = 29042
    protocol    = "tcp"
    cidr_blocks = var.subnet_cidr_blocks
  }

  ingress {
    description = "Metadata service"
    from_port   = 29080
    to_port     = 29080
    protocol    = "tcp"
    cidr_blocks = var.subnet_cidr_blocks
  }

  tags = {
    Name = "${var.name}-astradb-access"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_endpoint" "this" {
  vpc_id             = var.vpc_id
  service_name       = astra_private_link.this.service_name
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.subnet_ids
  security_group_ids = [aws_security_group.database_access.id]

  tags = {
    Name = "${var.name}-astradb"
  }
}

resource "astra_private_link_endpoint" "this" {
  database_id   = astra_database.this.id
  datacenter_id = "${astra_database.this.id}-1"
  endpoint_id   = aws_vpc_endpoint.this.id
}

resource "aws_route53_record" "this" {
  for_each = toset(var.zone_ids)

  zone_id = each.value
  name    = "${astra_database.this.id}-${data.aws_region.current.name}"
  type    = "CNAME"
  ttl     = "300"

  records = [reverse(sort(aws_vpc_endpoint.this.dns_entry[*].dns_name))[0]] # NOTE: Use the non-endpoint-specific DNS hostname
}


# Management VPC astra private links

resource "aws_security_group" "management_database_access" {
  name   = "${var.management_name}-astradb-access"
  vpc_id = var.vpc_id

  # NOTE: https://docs.datastax.com/en/astra/docs/datastax-astra-faq.html#_which_ports_are_used_by_serverless_databases
  # TODO: Use security groups instead of network?
  ingress {
    description = "REST, GraphQL and Astra DB Health dashboard"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.management_subnet_cidr_blocks
  }

  ingress {
    description = "CQL"
    from_port   = 29042
    to_port     = 29042
    protocol    = "tcp"
    cidr_blocks = var.management_subnet_cidr_blocks
  }

  ingress {
    description = "Metadata service"
    from_port   = 29080
    to_port     = 29080
    protocol    = "tcp"
    cidr_blocks = var.management_subnet_cidr_blocks
  }

  tags = {
    Name = "${var.management_name}-astradb-access"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_endpoint" "management" {
  vpc_id             = var.management_vpc_id
  service_name       = astra_private_link.this.service_name
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.management_subnet_ids
  security_group_ids = [aws_security_group.management_database_access.id]

  tags = {
    Name = "${var.management_name}-astradb"
  }
}

resource "astra_private_link_endpoint" "management" {
  endpoint_id   = aws_vpc_endpoint.example.id
  database_id   = astra_database.this.id
  datacenter_id = "${astra_database.this.id}-1"
  endpoint_id   = aws_vpc_endpoint.management.id
}