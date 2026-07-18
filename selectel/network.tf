# Terraform-конфигурация этого файла описывает часть облачной инфраструктуры.


# Берём актуальный образ Ubuntu для виртуальных машин.
data "openstack_images_image_v2" "ubuntu" {
  name        = "Ubuntu 24.04 LTS 64-bit"
  most_recent = true
}

# Создаём облачную сеть.
resource "openstack_networking_network_v2" "network_a" {
  name = "network-a"
}

# Описываем подсеть и её адресный диапазон.
resource "openstack_networking_subnet_v2" "subnet_a" {
  name       = "subnet-a"
  network_id = openstack_networking_network_v2.network_a.id
  cidr       = "10.10.0.0/18"
  ip_version = 4
}

# Создаём облачную сеть.
resource "openstack_networking_network_v2" "network_b" {
  name = "network-b"
}

# Описываем подсеть и её адресный диапазон.
resource "openstack_networking_subnet_v2" "subnet_b" {
  name       = "subnet-b"
  network_id = openstack_networking_network_v2.network_b.id
  cidr       = "10.100.0.0/16"
  ip_version = 4
}

# Создаём облачную сеть.
resource "openstack_networking_network_v2" "network_c" {
  name = "network-c"
}

# Описываем подсеть и её адресный диапазон.
resource "openstack_networking_subnet_v2" "subnet_c" {
  name       = "subnet-c"
  network_id = openstack_networking_network_v2.network_c.id
  cidr       = "10.20.0.0/26"
  ip_version = 4
}

# Настраиваем маршрутизацию между сетями.
resource "openstack_networking_router_v2" "main_router" {
  name           = "main-router"
  admin_state_up = true
}

# Настраиваем маршрутизацию между сетями.
resource "openstack_networking_router_interface_v2" "router_iface_a" {
  router_id = openstack_networking_router_v2.main_router.id
  subnet_id = openstack_networking_subnet_v2.subnet_a.id
}

# Настраиваем маршрутизацию между сетями.
resource "openstack_networking_router_interface_v2" "router_iface_b" {
  router_id = openstack_networking_router_v2.main_router.id
  subnet_id = openstack_networking_subnet_v2.subnet_b.id
}

# Настраиваем маршрутизацию между сетями.
resource "openstack_networking_router_interface_v2" "router_iface_c" {
  router_id = openstack_networking_router_v2.main_router.id
  subnet_id = openstack_networking_subnet_v2.subnet_c.id
}
