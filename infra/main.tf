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
  host = "localhost:8080"
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

  callback_urls                        = [local.host]
  default_redirect_uri                 = local.host
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]

  # generate_secret = true
}
