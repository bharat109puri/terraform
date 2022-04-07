output "database_id" {
  description = "AstraDB database ID"
  value       = astra_database.this.id
}

output "organization_id" {
  description = "AstraDB organization ID"
  value       = astra_database.this.organization_id
}
