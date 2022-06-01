variable "aliases" {
  description = "Aliases for the CloudFront distribution (must belong to `zone_id` if specified as FQDN)"
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the CloudFront distribution (WAF-based IP whitelisting)"
  type        = list(string)
  default     = []
}

variable "cors_rule" {
  description = "CORS rule to apply on the origin bucket"
  type        = map(any)
  default     = {}
}

variable "name" {
  description = "Hostname of the CloudFront distribution and suffix of the origin bucket (`recrd-{var.name}`)"
  type        = string
}

variable "zone_id" {
  description = "Zone ID to register the CloudFront endpoint"
  type        = string
}

variable "response_headers_policy_id" {
  description = "The unique identifier of the origin request policy that is attached to the behavior"
  type        = string
}

variable "smooth_streaming" {
  description = "Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior"
  type        = bool
}
