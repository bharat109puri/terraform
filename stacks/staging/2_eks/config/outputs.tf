output "deploy_role_name" {
  description = "Name of the `deploy` Role"
  value       = kubernetes_role_v1.deploy.metadata[0].name
}
