variable "account_id" {
  description = "Номер аккаунта Selectel (можно посмотреть в правом верхнем углу личного кабинета)"
  type        = string
  sensitive   = true
}

variable "service_user" {
  description = "Имя сервисного пользователя с ролями member и iam.admin"
  type        = string
  sensitive   = true
}

variable "service_password" {
  description = "Пароль сервисного пользователя"
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "ID проекта в Selectel OpenStack (можно найти в панели управления)"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Регион Selectel, например ru-9"
  type        = string
  default     = "ru-9"
}

# Ключ для доступа к серверам по SSH
variable "public_ssh_key" {
  description = "Публичный SSH-ключ для доступа к виртуальным машинам"
  type        = string
  sensitive   = true
}

# Имена сетей
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