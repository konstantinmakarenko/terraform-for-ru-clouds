output "ws11_public_ip" {
  description = "Публичный IP для доступа к ws11"
  value       = selectel_vpc_floatingip_v2.ws11_floatingip.floating_ip_address
}

output "ws11_private_ip" {
  value = "10.10.0.2"
}

output "r1_ips" {
  value = {
    eth0 = "10.10.0.1"
    eth1 = "10.100.0.11"
  }
}

output "r2_ips" {
  value = {
    eth0 = "10.100.0.12"
    eth1 = "10.20.0.1"
  }
}

output "ws21_ip" {
  value = "10.20.0.10"
}

output "ws22_ip" {
  value = "10.20.0.20"
}