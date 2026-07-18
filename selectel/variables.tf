# Terraform-конфигурация этого файла описывает часть облачной инфраструктуры.


variable "account_id" {
  type      = string
  sensitive = true
}

variable "service_user" {
  type      = string
  sensitive = true
}

variable "service_password" {
  type      = string
  sensitive = true
}

variable "project_id" {
  type      = string
  sensitive = true
}

variable "region" {
  type    = string
  default = "ru-9"
}

variable "public_ssh_key" {
  type      = string
  sensitive = true
}
