variable "auth_key_id" {
  type        = string
  description = "ID ключа сервисного аккаунта"
  sensitive   = true
}
variable "auth_secret" {
  type        = string
  description = "Секрет сервисного аккаунта"
  sensitive   = true
}
variable "project_id" {
  type        = string
  description = "ID проекта в Cloud.ru"
}
variable "public_ssh_key" {
  type        = string
  description = "Публичный SSH-ключ"
}
variable "zone" {
  type        = string
  default     = "ru-moscow-1" # Уточните в документации Evolution
}
variable "network_a_cidr" {
  type    = string
  default = "10.10.0.0/18"
}
variable "network_b_cidr" {
  type    = string
  default = "10.100.0.0/16"
}
variable "network_c_cidr" {
  type    = string
  default = "10.20.0.0/26"
}