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
