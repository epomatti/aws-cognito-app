variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "domain" {
  type    = string
  default = "myapp999"
}

variable "mfa" {
  type    = string
  default = "OFF"
}

# variable "callback_urls" {
#   type = list(string)
# }

# variable "logout_urls" {
#   type = list(string)
# }

# # Google
# variable "google_client_id" {
#   type = string
# }

# variable "google_client_secret" {
#   type = string
# }
