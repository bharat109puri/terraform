variable "name" {
  description = "AstraDB database name"
  type        = string
}

variable "subnet_cidr_blocks" {
  description = "TEMP: List CIDR blocks to access the database, this should be replaced by list of security groups"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for the database PrivateLink endpoints"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the database PrivateLink endpoints"
  type        = string
}

variable "zone_ids" {
  description = "List of zone IDs to register the PrivateLink endpoints in (Should be IDs of `apps.astra.datastax.com` and `db.astra.datastax.com`)"
  type        = list(string)
}


variable "management_name" {
  description = "AstraDB database name"
  type        = string
}

variable "management_subnet_cidr_blocks" {
  description = "TEMP: List CIDR blocks to access the database, this should be replaced by list of security groups"
  type        = list(string)
}

variable "management_subnet_ids" {
  description = "List of subnet IDs for the database PrivateLink endpoints"
  type        = list(string)
}

variable "management_vpc_id" {
  description = "VPC ID for the database PrivateLink endpoints"
  type        = string
}