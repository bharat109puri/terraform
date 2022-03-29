data "aws_route53_zone" "selected" {
  zone_id = var.zone_id
}

locals {
  fqdn = "${var.name}.${data.aws_route53_zone.selected.name}"
}
