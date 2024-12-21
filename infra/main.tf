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

module "iam" {
  source = "./modules/iam"
}

module "cognito_user_pool" {
  source                       = "./modules/cognito/user-pool"
  app_name                     = var.app_name
  username_attributes          = var.username_attributes
  auto_verified_attributes     = var.auto_verified_attributes
  mfa_configuration            = var.mfa_configuration
  allow_admin_create_user_only = var.allow_admin_create_user_only

  # SMS
  sms_role_arn               = module.iam.cognito_sms_role_arn
  sms_authentication_message = var.sms_authentication_message
  sms_external_id            = module.iam.cognito_sms_external_id
  sms_region                 = var.aws_region

  # Password policy
  minimum_length                   = var.minimum_length
  require_lowercase                = var.require_lowercase
  require_numbers                  = var.require_numbers
  require_symbols                  = var.require_symbols
  require_uppercase                = var.require_uppercase
  temporary_password_validity_days = var.temporary_password_validity_days
  password_history_size            = var.password_history_size

  depends_on = [module.iam]
}
