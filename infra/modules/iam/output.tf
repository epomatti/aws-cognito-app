output "cognito_sms_external_id" {
  value = random_uuid.cognito_sms_external_id.result
}

output "cognito_sms_role_arn" {
  value = aws_iam_role.cognito_sms.arn
}
