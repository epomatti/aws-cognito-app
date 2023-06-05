output "cognito_oidc_issuer_endpoint_url" {
  value       = "https://${aws_cognito_user_pool.main.endpoint}"
  description = "This is the OIDC Issuer endpoint URL"
}

output "cognito_client_id" {
  value = aws_cognito_user_pool_client.main.id
}

output "cognito_get_client_secret_command" {
  value = "aws cognito-idp describe-user-pool-client --user-pool-id ${aws_cognito_user_pool.main.id} --client-id ${aws_cognito_user_pool_client.main.id}"
}

output "cognito_client_name" {
  value = aws_cognito_user_pool_client.main.name
}
