# Создаём три приватные сети
resource "openstack_networking_network_v2" "network_a" {
  name           = "network-a"
  admin_state_up = true
}

resource "openstack_networking_network_v2" "network_b" {
  name           = "network-b"
  admin_state_up = true
}

resource "openstack_networking_network_v2" "network_c" {
  name           = "network-c"
  admin_state_up = true
}

# Создаём подсети для каждой сети
resource "openstack_networking_subnet_v2" "subnet_a" {
  name        = "subnet-a"
  network_id  = openstack_networking_network_v2.network_a.id
  cidr        = var.network_a_cidr
  ip_version  = 4
  enable_dhcp = true
}

resource "openstack_networking_subnet_v2" "subnet_b" {
  name        = "subnet-b"
  network_id  = openstack_networking_network_v2.network_b.id
  cidr        = var.network_b_cidr
  ip_version  = 4
  enable_dhcp = true
}

resource "openstack_networking_subnet_v2" "subnet_c" {
  name        = "subnet-c"
  network_id  = openstack_networking_network_v2.network_c.id
  cidr        = var.network_c_cidr
  ip_version  = 4
  enable_dhcp = true
}

# Создаём маршрутизатор для связи сетей между собой
resource "openstack_networking_router_v2" "router_1" {
  name                = "main-router"
  admin_state_up      = true
}

# Подключаем подсети к маршрутизатору через интерфейсы
resource "openstack_networking_router_interface_v2" "router_interface_a" {
  router_id = openstack_networking_router_v2.router_1.id
  subnet_id = openstack_networking_subnet_v2.subnet_a.id
}

resource "openstack_networking_router_interface_v2" "router_interface_b" {
  router_id = openstack_networking_router_v2.router_1.id
  subnet_id = openstack_networking_subnet_v2.subnet_b.id
}

resource "openstack_networking_router_interface_v2" "router_interface_c" {
  router_id = openstack_networking_router_v2.router_1.id
  subnet_id = openstack_networking_subnet_v2.subnet_c.id
}