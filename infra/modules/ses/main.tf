resource "aws_sesv2_email_identity" "default" {
  email_identity = var.email_identity

  # configuration_set_name = aws_sesv2_configuration_set.example.configuration_set_name

  # dkim_signing_attributes {
  #   domain_signing_private_key = "MIIJKAIBAAKCAgEA2Se7p8zvnI4yh+Gh9j2rG5e2aRXjg03Y8saiupLnadPH9xvM..." #PEM private key without headers or newline characters
  #   domain_signing_selector    = "example"
  # }
}

# resource "aws_sesv2_configuration_set" "example" {
#   configuration_set_name = "example"
# }
