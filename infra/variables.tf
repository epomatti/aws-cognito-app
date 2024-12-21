variable "aws_region" {
  type    = string
  default = "us-east-2"
}

### Cognito ###

# User Pool
variable "app_name" {
  type = string
}

variable "username_attributes" {
  type = list(string)
}

variable "auto_verified_attributes" {
  type = list(string)
}

variable "mfa_configuration" {
  type = string
}

variable "allow_admin_create_user_only" {
  type = bool
}

# User Pool: Password policy
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



variable "domain" {
  type    = string
  default = "myapp999"
}

variable "mfa" {
  type    = string
  default = "OFF"
}

variable "callback_urls" {
  type = list(string)
}

variable "logout_urls" {
  type = list(string)
}

# Google
variable "google_client_id" {
  type = string
}

variable "google_client_secret" {
  type      = string
  sensitive = true
}
