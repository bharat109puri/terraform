output "id" {
  value = aws_iam_access_key.auth0_ses.id
}

output "secret" {
  value     = aws_iam_access_key.auth0_ses.secret
  sensitive = true
}
