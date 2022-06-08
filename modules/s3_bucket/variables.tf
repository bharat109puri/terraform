variable "cors_rule" {
  description = "CORS rule"
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  default = null
}

variable "enable_amazon_managed_encryption" {
  description = "SSE-S3 encryption instead of KMS"
  type        = bool
  default     = false
}

variable "name" {
  description = "Bucket name"
  type        = string
}
