variable "confluent_kafka_service_name" {
  description = "Confluent Cloud VPC Endpoint service name for the Kafka cluster (Cluster overview/Networking/Private Link Service)"
  type        = string
}

variable "name" {
  description = "Kafka cluster name (just an ID for now)"
  type        = string
}

variable "bootstrap_endpoint" {
  description = "Kafka cluster bootstrap endpoint (Cluster overview/Cluster settings/General/Identification"
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
