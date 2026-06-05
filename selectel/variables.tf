variable "account_id" {
  description = "Номер аккаунта Selectel"
  type        = string
  sensitive   = true
}

variable "service_user" {
  description = "Имя сервисного пользователя"
  type        = string
  sensitive   = true
}

variable "service_password" {
  description = "Пароль сервисного пользователя"
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "ID проекта в Selectel OpenStack"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Регион Selectel"
  type        = string
  default     = "ru-9"
}

variable "public_ssh_key" {
  description = "Публичный SSH-ключ"
  type        = string
  sensitive   = true
}

variable "network_a_cidr" {
  description = "CIDR сети A"
  type        = string
  default     = "10.10.0.0/18"
}

variable "network_b_cidr" {
  description = "CIDR сети B"
  type        = string
  default     = "10.100.0.0/16"
}

variable "network_c_cidr" {
  description = "CIDR сети C"
  type        = string
  default     = "10.20.0.0/26"
}