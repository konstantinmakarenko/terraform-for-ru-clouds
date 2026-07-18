# Terraform-конфигурация этого файла описывает часть облачной инфраструктуры.


output "ws11_public_ip" {
  description = "Публичный IP для доступа к ws11 из интернета"
  value       = yandex_compute_instance.ws11.network_interface[0].nat_ip_address
}

output "ws11_private_ip" {
  description = "Приватный IP ws11"
  value       = yandex_compute_instance.ws11.network_interface[0].ip_address
}

output "r1_ips" {
  description = "IP-адреса маршрутизатора r1"
  value = {
    eth0 = yandex_compute_instance.r1.network_interface[0].ip_address
    eth1 = yandex_compute_instance.r1.network_interface[1].ip_address
  }
}

output "r2_ips" {
  description = "IP-адреса маршрутизатора r2"
  value = {
    eth0 = yandex_compute_instance.r2.network_interface[0].ip_address
    eth1 = yandex_compute_instance.r2.network_interface[1].ip_address
  }
}

output "ws21_ip" {
  description = "IP-адрес ws21"
  value       = yandex_compute_instance.ws21.network_interface[0].ip_address
}

output "ws22_ip" {
  description = "IP-адрес ws22"
  value       = yandex_compute_instance.ws22.network_interface[0].ip_address
}
