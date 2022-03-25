variable "recrd_admins" {
  description = "List of email addresses used as user name for admins. Specify only `@recrd.com` emails"
  type        = list(string)
}

variable "recrd_developers" {
  description = "List of email addresses used as user name for Recrd Developers. Specify only `@recrd.com` emails"
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
