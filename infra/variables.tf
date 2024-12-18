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
