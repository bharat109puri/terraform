locals {
  # Confluent Cloud doesn't give us the private URLs we need, extract the cluster-specific subdomain from the bootstrap endpoint
  _bootstrap_glb_hostname         = trimsuffix(var.bootstrap_endpoint, ".${data.aws_region.current.name}.aws.glb.confluent.cloud:9092")
  _bootstrap_custer_domain_prefix = reverse(split("-", local._bootstrap_glb_hostname))[0]

  # Non zone-specific VPC endpoint
  vpce_common = reverse(sort(aws_vpc_endpoint.this.dns_entry[*].dns_name))[0]

  # Map AZ IDs (used by Confluent-side certificates) into AZ names (used by VPC endpoints on our side)
  _vpce_prefix = split(".", local.vpce_common)[0]
  _vpce_domain = trimprefix(local.vpce_common, "${local._vpce_prefix}.")
  _az_map      = zipmap(data.aws_availability_zones.available.zone_ids, data.aws_availability_zones.available.names)

  # Hosted zone domain on our side
  cluster_domain = "${local._bootstrap_custer_domain_prefix}.${data.aws_region.current.name}.aws.confluent.cloud"

  # Zone-specific CNAMEs
  cnames = {
    for zone_id in keys(local._az_map) :
    zone_id => "${local._vpce_prefix}-${local._az_map[zone_id]}.${local._vpce_domain}"
  }
}

data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_region" "current" {}

resource "aws_security_group" "this" {
  name   = "${var.name}-confluent-kafka-access"
  vpc_id = var.vpc_id

  # NOTE: https://docs.confluent.io/cloud/current/networking/private-links/aws-privatelink.html#set-up-the-vpc-endpoint-for-aws-privatelink-in-your-aws-account
  # TODO: Use security groups instead of network?
  ingress {
    description = "HTTP redirect"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.subnet_cidr_blocks
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.subnet_cidr_blocks
  }

  ingress {
    description = "Kafka"
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = var.subnet_cidr_blocks
  }

  tags = {
    Name = "${var.name}-confluent-kafka-access"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_endpoint" "this" {
  vpc_id             = var.vpc_id
  service_name       = var.confluent_kafka_service_name
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.subnet_ids
  security_group_ids = [aws_security_group.this.id]

  tags = {
    Name = "${var.name}-confluent-kafka"
  }
}

resource "aws_route53_zone" "cluster_domain" {
  name = local.cluster_domain

  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "common" {
  zone_id = aws_route53_zone.cluster_domain.id
  name    = "*"
  type    = "CNAME"
  ttl     = "300"

  records = [local.vpce_common]
}

resource "aws_route53_record" "zonal" {
  for_each = local.cnames

  zone_id = aws_route53_zone.cluster_domain.id
  name    = "*.${each.key}"
  type    = "CNAME"
  ttl     = "300"

  records = [each.value]
}
