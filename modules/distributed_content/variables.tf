variable "name" {
  description = "Hostname of the CloudFront distribution and suffix of the origin bucket (`recrd-{var.name}`)"
  type        = string
}

variable "zone_id" {
  description = "Zone ID to register the CloudFront endpoint"
  type        = string
}
