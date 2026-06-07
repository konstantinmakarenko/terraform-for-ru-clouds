variable "auth_key_id" {
  description = "ID ключа сервисного аккаунта"
  type        = string
  sensitive   = true
}

variable "auth_secret" {
  description = "Секрет сервисного аккаунта"
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "ID проекта в Cloud.ru"
  type        = string
}

variable "public_ssh_key" {
  description = "Публичный SSH-ключ"
  type        = string
  sensitive   = true
}

variable "zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-moscow-1"
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