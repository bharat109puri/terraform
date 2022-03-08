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
  description = "Map to define third party access. Stucture: {\"third_party_name\" = [\"email_1\"], \"email_2\"}"
  type        = map(list(string))
  default     = {}
}