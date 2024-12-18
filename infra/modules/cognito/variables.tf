variable "app_name" {
  type = string
}

variable "google_client_id" {
  type = string
}

variable "google_client_secret" {
  type = string
}

variable "domain" {
  type = string
}

variable "callback_urls" {
  type = list(string)
}

variable "logout_urls" {
  type = list(string)
}

variable "mfa_configuration" {
  
}