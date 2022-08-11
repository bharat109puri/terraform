variable "ec_token" {
  description = "Elastic Cloud API key"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "tfe_token" {
  description = "Terraform Cloud Team token"
  type        = string
  sensitive   = true
}

variable "elastic_name" {
  description = "elastic cluster name"
  type        = string
}


variable "elastic_version" {
  description = "elastic version"
  type        = string
}

variable "topology" {
  type = list(object({
    id                   = string
    zone_count           = number
    size                 = string
    autoscaling_max_size = string
  }))
  nullable = true
}
