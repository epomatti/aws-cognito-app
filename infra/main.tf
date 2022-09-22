terraform {
  backend "local" {
    path = ".workspace/terraform.tfstate"
  }
}

provider "aws" {
  region = var.region
}


# TODO: Verify attribute changes
resource "aws_cognito_user_pool" "main" {
  name = "mypool"
  // alias_attributes         = ["email"]
  username_attributes      = ["email"]
  mfa_configuration        = "OFF"
  auto_verified_attributes = ["email"]

  admin_create_user_config {
    # Enable self-registration
    allow_admin_create_user_only = false
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  # This will add email as a required attribute
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
}

resource "aws_cognito_identity_provider" "google" {
  user_pool_id  = aws_cognito_user_pool.main.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes = "email"
    client_id        = var.google_client_id
    client_secret    = var.google_client_secret
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.domain
  user_pool_id = aws_cognito_user_pool.main.id
}

resource "aws_cognito_user_pool_client" "main" {
  name                                 = "client-app"
  user_pool_id                         = aws_cognito_user_pool.main.id
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls
  allowed_oauth_flows_user_pool_client = true
  # explicit_auth_flows = [
  #   "ALLOW_REFRESH_TOKEN_AUTH",
  #   "ALLOW_USER_SRP_AUTH",
  # ]
  generate_secret              = true
  allowed_oauth_flows          = ["code"]
  allowed_oauth_scopes         = ["email", "openid", "profile"]
  supported_identity_providers = ["COGNITO", aws_cognito_identity_provider.google.provider_name]
}


### Outputs ###

output "cognito_oidc_issuer_endpoint" {
  value       = aws_cognito_user_pool.main.endpoint
  description = "This is the OIDC Issuer endpoint"
}

output "cognito_client_id" {
  value = aws_cognito_user_pool_client.main.id
}
