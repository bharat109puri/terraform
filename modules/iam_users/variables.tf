variable "recrd_admins" {
  description = "List of `admin` email addresses. Specify only `@recrd.com` emails"
  type        = list(string)
}

variable "recrd_developers" {
  description = "List of `developer` email addresses. Specify only `@recrd.com` emails"
  type        = list(string)
  default     = []
}

variable "third_parties" {
  description = "Map to define third party access"
  type = map(object({
    emails      = list(string)
    policy_arns = list(string)
  }))
  default = {}
}
