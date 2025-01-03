resource "random_string" "affix" {
  length  = 6
  special = false
  upper   = false
  numeric = false
}

# TODO: Verify attribute changes
resource "aws_cognito_user_pool" "main" {
  name = "${var.app_name}-${random_string.affix.result}"

  # This will not allow an alias
  # username_attributes      = var.username_attributes
  # auto_verified_attributes = var.auto_verified_attributes

  # username_attributes = [""]
  alias_attributes = [""]

  mfa_configuration          = var.mfa_configuration
  sms_authentication_message = var.sms_authentication_message

  sms_configuration {
    external_id    = var.sms_external_id
    sns_caller_arn = var.sms_role_arn
    sns_region     = var.sms_region
  }

  admin_create_user_config {
    # Disables self-registration
    allow_admin_create_user_only = var.allow_admin_create_user_only
  }

  # Will use SSO, no need for self-recovery
  account_recovery_setting {
    recovery_mechanism {
      name     = "admin_only"
      priority = 1
    }
  }

  # TODO: Change to corporate SES
  # email_configuration {
  #   email_sending_account  = "DEVELOPER"
  #   from_email_address     = var.from_email_address
  #   reply_to_email_address = var.from_email_address
  #   source_arn             = var.ses_email_identity_arn
  # }

  password_policy {
    minimum_length                   = var.minimum_length
    require_lowercase                = var.require_lowercase
    require_numbers                  = var.require_numbers
    require_symbols                  = var.require_symbols
    require_uppercase                = var.require_uppercase
    temporary_password_validity_days = var.temporary_password_validity_days
    password_history_size            = var.password_history_size
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
