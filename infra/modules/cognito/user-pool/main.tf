# TODO: Verify attribute changes
resource "aws_cognito_user_pool" "main" {
  name = "${var.app_name}-pool"

  # Does not allow alias. Only one method for SSO
  username_attributes = ["email"]

  mfa_configuration        = var.mfa_configuration
  auto_verified_attributes = ["email"]

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
