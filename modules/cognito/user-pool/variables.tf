variable "app_name" {
  type = string
}

# variable "username_attributes" {
#   type = list(string)
# }

# variable "auto_verified_attributes" {
#   type = list(string)
# }

variable "mfa_configuration" {
  type = string
}

variable "allow_admin_create_user_only" {
  type = bool
}

# Email
# variable "ses_email_identity_arn" {
#   type = string
# }

# variable "from_email_address" {
#   type = string
# }

# SMS
variable "sms_role_arn" {
  type = string
}

variable "sms_authentication_message" {
  type = string
}

variable "sms_external_id" {
  type = string
}

variable "sms_region" {
  type = string
}

# Password policy
variable "minimum_length" {
  type = number
}

variable "require_lowercase" {
  type = bool
}

variable "require_numbers" {
  type = bool
}

variable "require_symbols" {
  type = bool
}

variable "require_uppercase" {
  type = bool
}

variable "temporary_password_validity_days" {
  type = number
}

variable "password_history_size" {
  type = number
}
