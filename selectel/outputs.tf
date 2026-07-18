# Terraform-конфигурация этого файла описывает часть облачной инфраструктуры.


output "ws11_public_ip" {
  description = "Публичный IP для доступа к ws11"
  value       = selectel_vpc_floatingip_v2.ws11_floatingip.floating_ip_address
}

output "ws11_private_ip" {
  description = "Приватный IP ws11"
  value       = openstack_compute_instance_v2.ws11.network[0].fixed_ip_v4
}

output "r1_ips" {
  description = "IP-адреса маршрутизатора r1"
  value = {
    eth0 = openstack_compute_instance_v2.r1.network[0].fixed_ip_v4
    eth1 = openstack_compute_instance_v2.r1.network[1].fixed_ip_v4
  }
}

output "r2_ips" {
  description = "IP-адреса маршрутизатора r2"
  value = {
    eth0 = openstack_compute_instance_v2.r2.network[0].fixed_ip_v4
    eth1 = openstack_compute_instance_v2.r2.network[1].fixed_ip_v4
  }
}

output "ws21_ip" {
  description = "IP-адрес ws21"
  value       = openstack_compute_instance_v2.ws21.network[0].fixed_ip_v4
}

output "ws22_ip" {
  description = "IP-адрес ws22"
  value       = openstack_compute_instance_v2.ws22.network[0].fixed_ip_v4
}
