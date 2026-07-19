# Terraform-конфигурация этого файла описывает выводимые значения Cloud.ru.

output "ws11_public_ip" {
  description = "Публичный IP для доступа к ws11"
  value       = cloudru_evolution_compute_interface.ws11.external_ip.ip_address
}

output "ws11_private_ip" {
  description = "Приватный IP ws11"
  value       = cloudru_evolution_compute_interface.ws11.ip_address
}

output "r1_ips" {
  description = "IP-адреса r1"
  value = {
    eth0 = cloudru_evolution_compute_interface.r1_a.ip_address
    eth1 = cloudru_evolution_compute_interface.r1_b.ip_address
  }
}

output "r2_ips" {
  description = "IP-адреса r2"
  value = {
    eth0 = cloudru_evolution_compute_interface.r2_b.ip_address
    eth1 = cloudru_evolution_compute_interface.r2_c.ip_address
  }
}

output "ws21_ip" {
  description = "IP-адрес ws21"
  value       = cloudru_evolution_compute_interface.ws21.ip_address
}

output "ws22_ip" {
  description = "IP-адрес ws22"
  value       = cloudru_evolution_compute_interface.ws22.ip_address
}