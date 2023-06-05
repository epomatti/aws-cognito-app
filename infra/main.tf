terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.1.0"
    }
  }
  backend "local" {
    path = ".workspace/terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}

# TODO: Verify attribute changes
resource "aws_cognito_user_pool" "main" {
  name = "mypool"
  # Does not allow alias. Only one method for SSO
  username_attributes = ["email"]
  # mfa_configuration        = var.mfa
  auto_verified_attributes = ["email"]

  admin_create_user_config {
    # This will disable self-registration
    allow_admin_create_user_only = true
  }

  # Will use SSO, no need for self-recovery
  account_recovery_setting {
    recovery_mechanism {
      name     = "admin_only"
      priority = 1
    }
  }

  # TODO: Change to corporate SES
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  # # This will add email as a required attribute
  # schema {
  #   attribute_data_type      = "String"
  #   developer_only_attribute = false
  #   mutable                  = true
  #   name                     = "email"
  #   required                 = true

  #   string_attribute_constraints {
  #     min_length = 1
  #     max_length = 256
  #   }
  # }
}

resource "aws_cognito_identity_provider" "google" {
  user_pool_id  = aws_cognito_user_pool.main.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes = "email"
    client_id        = var.google_client_id
    client_secret    = var.google_client_secret

    # TODO: Dynamic options. Read AWS docs for more info
    "attributes_url"                = "https://people.googleapis.com/v1/people/me?personFields="
    "attributes_url_add_attributes" = "true"
    "authorize_url"                 = "https://accounts.google.com/o/oauth2/v2/auth"
    "oidc_issuer"                   = "https://accounts.google.com"
    "token_request_method"          = "POST"
    "token_url"                     = "https://www.googleapis.com/oauth2/v4/token"
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
}

# TODO: Create custom domain
# This will create the Hosted UI experience
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
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
  ]
  generate_secret              = true
  allowed_oauth_flows          = ["code"]
  allowed_oauth_scopes         = ["email", "openid", "profile"]
  supported_identity_providers = [aws_cognito_identity_provider.google.provider_name]

  # To make it easy during development
  lifecycle {
    ignore_changes = [
      callback_urls, logout_urls
    ]
  }
}

# # TODO: Customize
# resource "aws_cognito_user_pool_ui_customization" "example" {
#   client_id = aws_cognito_user_pool_client.main.id

#   # css        = ".label-customizable {font-weight: 400;}"
#   image_file = filebase64("logo.png")

#   # Refer to the aws_cognito_user_pool_domain resource's
#   # user_pool_id attribute to ensure it is in an 'Active' state
#   user_pool_id = aws_cognito_user_pool_domain.main.user_pool_id
# }


# TODO: Risk configuration
# resource "aws_cognito_risk_configuration" "main" {
#   user_pool_id = aws_cognito_user_pool.main.id
#   account_takeover_risk_configuration {
#     actions {
#       low_action {
#         event_action = "MFA_REQUIRED"
#         notify       = true
#       }
#       medium_action {
#         event_action = "MFA_REQUIRED"
#         notify       = true
#       }
#       high_action {
#         event_action = "MFA_REQUIRED"
#         notify       = true
#       }
#     }
#   }
#   compromised_credentials_risk_configuration {

#   }
# }
