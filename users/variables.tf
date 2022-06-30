variable "region" {
  description = "AWS region"
  type        = string
}


variable "recrd_admins" {
  description = "List of `admin` email addresses. Specify only `@recrd.com` emails"
  type        = list(string)
  default = [
    "abu@recrd.com",
    "alexey@recrd.com",
    "bharat@recrd.com",
    "dmitry@recrd.com",
    "sree@recrd.com"
  ]
}

variable "recrd_developers" {
  description = "List of `developer` email addresses. Specify only `@recrd.com` emails"
  type        = list(string)
  default = [
    "alex@recrd.com",
    "alexey@recrd.com",
    "anton@recrd.com",
    "chijioke@recrd.com",
    "roberto@recrd.com"
  ]
}
