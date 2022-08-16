output "database_id" {
  description = "AstraDB database ID"
  value       = module.cassandra_database.database_id
}

output "organization_id" {
  description = "AstraDB organization ID"
  value       = module.cassandra_database.organization_id
}
