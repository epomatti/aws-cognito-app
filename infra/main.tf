terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
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
}
