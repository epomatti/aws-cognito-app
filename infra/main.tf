terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.21.0"
    }
  }
}

provider "aws" {
  region = "sa-east-1"
}

locals {
  host = "localhost:5036/signin-oidc"
}

resource "aws_cognito_user_pool" "pool" {
  name = "mypool"
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "pomattipool"
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_pool_client" "client" {
  name         = "client"
  user_pool_id = aws_cognito_user_pool.pool.id

  callback_urls        = [local.host]
  default_redirect_uri = local.host
  explicit_auth_flows  = ["ADMIN_NO_SRP_AUTH"]
  # allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows          = ["code"]
  allowed_oauth_scopes         = ["email", "openid", "profile"]
  supported_identity_providers = ["COGNITO"]
}
