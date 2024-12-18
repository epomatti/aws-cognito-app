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

module "cognito" {
  source               = "./modules/cognito"
  google_client_id     = var.google_client_id
  google_client_secret = var.google_client_secret
  domain               = var.domain
  callback_urls        = var.callback_urls
  logout_urls          = var.logout_urls
}
