variable "aliases" {
  description = "Aliases for the CloudFront distribution (must belong to `zone_id` if specified as FQDN)"
  type        = list(string)
  default     = []
}

variable "name" {
  description = "Hostname of the CloudFront distribution and suffix of the origin bucket (`recrd-{var.name}`)"
  type        = string
}

variable "zone_id" {
  description = "Zone ID to register the CloudFront endpoint"
  type        = string
}
