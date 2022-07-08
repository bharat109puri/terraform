variable "owner_env" {}
variable "owner_region" {}
variable "accepter_region" {}
variable "accepter_env" {}

variable "owner_vpc_id" {
  description = "Owner VPC Id"
}

variable "accepter_vpc_id" {
  description = "Accepter VPC Id"
}
