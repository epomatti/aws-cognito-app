terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "cognito_user_pool" {
  source                       = "./modules/cognito/user-pool"
  app_name                     = var.app_name
  username_attributes          = var.username_attributes
  auto_verified_attributes     = var.auto_verified_attributes
  mfa_configuration            = var.mfa_configuration
  allow_admin_create_user_only = var.allow_admin_create_user_only

  # Password policy
  minimum_length                   = var.minimum_length
  require_lowercase                = var.require_lowercase
  require_numbers                  = var.require_numbers
  require_symbols                  = var.require_symbols
  require_uppercase                = var.require_uppercase
  temporary_password_validity_days = var.temporary_password_validity_days
  password_history_size            = var.password_history_size
}
