data "aws_region" "current" {}

resource "aws_security_group" "this" {
  description = "Security group for accessing Elastic Cloud Interface Endpoint"

  name   = "elastic-cloud-access"
  vpc_id = var.vpc_id

  # NOTE: https://www.elastic.co/guide/en/cloud-enterprise/2.1/ece-connect.html#ece-connect
  # FIXME: "Port 9200 is used for HTTP connections, ports 9243 and 443 are used for HTTPS"
  # FIXME: "A good choice if your applications are using Java. This lighter-weight transport client forwards requests to a remote cluster over port 9300, ..."
  ingress {
    security_groups = var.allowed_security_group_ids
    protocol        = "-1"
    from_port       = "0"
    to_port         = "0"
    self            = "false"
  }
}

resource "aws_vpc_endpoint" "this" {
  vpc_id            = var.vpc_id
  service_name      = local.elastic_private_link_endpoints[data.aws_region.current.name].service_name
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.this.id
  ]

  subnet_ids = var.subnet_ids
}

resource "aws_route53_zone" "this" {
  name = local.elastic_private_link_endpoints[data.aws_region.current.name].domain_name

  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "this" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "*"
  type    = "CNAME"
  ttl     = "300"

  records = [
    reverse(sort(aws_vpc_endpoint.this.dns_entry[*].dns_name))[0] # NOTE: Use the non-endpoint-specific DNS hostname
  ]
}
