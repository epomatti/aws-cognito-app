terraform {
  backend "local" {
    path = ".workspace/terraform.tfstate"
  }
}

provider "aws" {
  region = var.region
}


locals {
  host = "localhost:5036/signin-oidc"
}

resource "aws_cognito_user_pool" "default" {
  name                     = "mypool"
  alias_attributes         = ["email"]
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
}

# resource "aws_cognito_user_pool_domain" "main" {
#   domain       = "myapp"
#   user_pool_id = aws_cognito_user_pool.pool.id
# }

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
