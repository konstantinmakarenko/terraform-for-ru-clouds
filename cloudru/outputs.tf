output "ws11_public_ip" {
  value = cloudru_compute_floating_ip.ws11_floating_ip.address
}
output "ws11_private_ip" {
  value = cloudru_compute_vm.ws11.network_interface[0].ip_address
}
output "r1_ips" {
  value = {
    eth0 = cloudru_compute_vm.r1.network_interface[0].ip_address
    eth1 = cloudru_compute_vm.r1.network_interface[1].ip_address
  }
}
output "r2_ips" {
  value = {
    eth0 = cloudru_compute_vm.r2.network_interface[0].ip_address
    eth1 = cloudru_compute_vm.r2.network_interface[1].ip_address
  }
}
output "ws21_ip" {
  value = cloudru_compute_vm.ws21.network_interface[0].ip_address
}
output "ws22_ip" {
  value = cloudru_compute_vm.ws22.network_interface[0].ip_address
}