# Создаём три сети
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

# Создаём подсети (без gateway, чтобы не конфликтовать)
resource "openstack_networking_subnet_v2" "subnet_a" {
  name        = "subnet-a"
  network_id  = openstack_networking_network_v2.network_a.id
  cidr        = var.network_a_cidr
  ip_version  = 4
  enable_dhcp = true
  gateway_ip  = null  # Отключаем автоматический gateway
}

resource "openstack_networking_subnet_v2" "subnet_b" {
  name        = "subnet-b"
  network_id  = openstack_networking_network_v2.network_b.id
  cidr        = var.network_b_cidr
  ip_version  = 4
  enable_dhcp = true
  gateway_ip  = null
}

resource "openstack_networking_subnet_v2" "subnet_c" {
  name        = "subnet-c"
  network_id  = openstack_networking_network_v2.network_c.id
  cidr        = var.network_c_cidr
  ip_version  = 4
  enable_dhcp = true
  gateway_ip  = null
}

# Создаём роутер
resource "openstack_networking_router_v2" "main_router" {
  name                = "main-router"
  admin_state_up      = true
}

# Добавляем интерфейсы роутера в подсети (теперь без конфликта IP)
resource "openstack_networking_router_interface_v2" "router_iface_a" {
  router_id = openstack_networking_router_v2.main_router.id
  subnet_id = openstack_networking_subnet_v2.subnet_a.id
}

resource "openstack_networking_router_interface_v2" "router_iface_b" {
  router_id = openstack_networking_router_v2.main_router.id
  subnet_id = openstack_networking_subnet_v2.subnet_b.id
}

resource "openstack_networking_router_interface_v2" "router_iface_c" {
  router_id = openstack_networking_router_v2.main_router.id
  subnet_id = openstack_networking_subnet_v2.subnet_c.id
}