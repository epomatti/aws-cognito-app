terraform {
  backend "local" {
    path = ".workspace/terraform.tfstate"
  }
}

provider "aws" {
  region = var.region
}

# locals {
#   host = "localhost:5036/signin-oidc"
# }

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

resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.domain
  user_pool_id = aws_cognito_user_pool.main.id
}

resource "aws_cognito_user_pool_client" "main" {
  name         = "client-app"
  user_pool_id = aws_cognito_user_pool.main.id

  callback_urls = var.callback_urls
  allowed_oauth_scopes         = ["email", "openid", "profile"]
  
  # default_redirect_uri = local.host
  # explicit_auth_flows = ["ADMIN_NO_SRP_AUTH"]
  # allowed_oauth_flows_user_pool_client = true
  # allowed_oauth_flows          = ["code"]
  # supported_identity_providers = ["COGNITO"]
}





# resource "aws_cognito_user_pool_client" "client" {
#   name         = "client"
#   user_pool_id = aws_cognito_user_pool.pool.id

#   callback_urls        = [local.host]
#   default_redirect_uri = local.host
#   explicit_auth_flows  = ["ADMIN_NO_SRP_AUTH"]
#   # allowed_oauth_flows_user_pool_client = true
#   allowed_oauth_flows          = ["code"]
#   allowed_oauth_scopes         = ["email", "openid", "profile"]
#   supported_identity_providers = ["COGNITO"]
# }


# resource "aws_cognito_user_pool_client" "client" {
#   name = "cognito-client"

#   user_pool_id = aws_cognito_user_pool.user_pool.id
#   generate_secret = false
#   refresh_token_validity = 90
#   prevent_user_existence_errors = "ENABLED"
#   explicit_auth_flows = [
#     "ALLOW_REFRESH_TOKEN_AUTH",
#     "ALLOW_USER_PASSWORD_AUTH",
#     "ALLOW_ADMIN_USER_PASSWORD_AUTH"
#   ]

# }






output "cognito_userpool_custom_domain" {
  value = aws_cognito_user_pool.main.custom_domain
}

output "cognito_userpool_domain" {
  value = aws_cognito_user_pool.main.domain
}

output "cognito_userpool_endpoint" {
  value = aws_cognito_user_pool.main.endpoint
}
