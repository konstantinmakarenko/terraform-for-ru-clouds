# Terraform-конфигурация этого файла описывает часть облачной инфраструктуры.


variable "cloud_id" {
  description = "ID облака Yandex Cloud"
  type        = string
  sensitive   = true
}

variable "folder_id" {
  description = "ID каталога Yandex Cloud"
  type        = string
  sensitive   = true
}

variable "token" {
  description = "OAuth-токен или IAM-токен сервисного аккаунта"
  type        = string
  sensitive   = true
}

variable "public_ssh_key" {
  description = "Публичный SSH-ключ для доступа к ВМ"
  type        = string
  sensitive   = true
}

variable "default_zone" {
  description = "Зона доступности по умолчанию"
  type        = string
  default     = "ru-central1-a"
}

variable "network_a_cidr" {
  description = "CIDR сети A (10.10.0.0/18)"
  type        = string
  default     = "10.10.0.0/18"
}

variable "network_b_cidr" {
  description = "CIDR сети B (10.100.0.0/16)"
  type        = string
  default     = "10.100.0.0/16"
}

variable "network_c_cidr" {
  description = "CIDR сети C (10.20.0.0/26)"
  type        = string
  default     = "10.20.0.0/26"
}
