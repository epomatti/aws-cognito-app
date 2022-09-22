variable "region" {
  type = string
}

variable "domain" {
  type    = string
  default = "myapp-999"
}

variable "callback_urls" {
  type = list(string)
}

variable "logout_urls" {
  type = list(string)
}
