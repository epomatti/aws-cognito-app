variable "region" {
  type = string
}

variable "ec2_instance_types" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "secret" {
  type      = string
  sensitive = true
}

variable "issuer_base_url" {
  type = string
}
