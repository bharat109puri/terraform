variable "name" {
  description = "Label used to prefix multiple resources"
  type        = string
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

variable "vpc_cidr" {
  description = "VPC CIDR (specify a /16)"
  type        = string
}


### DNS Hostzones
variable "apps_astradb" {}
variable "db_astradb" {}
variable "recrd_zone" {}
