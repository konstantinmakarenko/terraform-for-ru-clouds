# Terraform-конфигурация этого файла описывает часть облачной инфраструктуры.


output "ws11_public_ip" {
  description = "Публичный IP для доступа к ws11"
  value       = cloudru_compute_floating_ip.ws11_floating_ip.address
}

output "ws11_private_ip" {
  description = "Приватный IP ws11"
  value       = "10.10.0.2"
}

output "r1_ips" {
  description = "IP-адреса r1"
  value = {
    eth0 = "10.10.0.1"
    eth1 = "10.100.0.11"
  }
}

output "r2_ips" {
  description = "IP-адреса r2"
  value = {
    eth0 = "10.100.0.12"
    eth1 = "10.20.0.1"
  }
}

output "ws21_ip" {
  description = "IP-адрес ws21"
  value       = "10.20.0.10"
}

output "ws22_ip" {
  description = "IP-адрес ws22"
  value       = "10.20.0.20"
}
