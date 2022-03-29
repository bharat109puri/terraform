variable "enable_amazon_managed_encryption" {
  description = "SSE-S3 encryption instead of KMS"
  type        = bool
  default     = false
}

variable "name" {
  description = "Bucket name"
  type        = string
}
