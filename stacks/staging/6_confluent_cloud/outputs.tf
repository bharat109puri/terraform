output "confluent_kafka_service_name" {
  description = "Confluent Cloud VPC Endpoint service name for the Kafka cluster (Cluster overview/Networking/Private Link Service)"
  value       = confluent_private_link_access.aws.private_link_endpoint_service
}

output "bootstrap_endpoint" {
  description = "Kafka cluster bootstrap endpoint (Cluster overview/Cluster settings/General/Identification)"
  value       = confluent_kafka_cluster.this.bootstrap_endpoint
}

output "schema_registry_endpoint" {
  description = "Schema Registry API endpoint to communicate with app"
  value       = ""
}
