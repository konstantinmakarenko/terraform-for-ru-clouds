# ===== ДАННЫЕ ОБ ОБРАЗЕ =====
data "openstack_images_image_v2" "ubuntu" {
  name        = "Ubuntu 24.04 LTS 64-bit"
  most_recent = true
}

# ===== СЕТИ =====
resource "openstack_networking_network_v2" "network_a" {
  name = "network-a"
}

resource "openstack_networking_subnet_v2" "subnet_a" {
  name       = "subnet-a"
  network_id = openstack_networking_network_v2.network_a.id
  cidr       = "10.10.0.0/18"
  ip_version = 4
}

resource "openstack_networking_network_v2" "network_b" {
  name = "network-b"
}

resource "openstack_networking_subnet_v2" "subnet_b" {
  name       = "subnet-b"
  network_id = openstack_networking_network_v2.network_b.id
  cidr       = "10.100.0.0/16"
  ip_version = 4
}

resource "openstack_networking_network_v2" "network_c" {
  name = "network-c"
}

resource "openstack_networking_subnet_v2" "subnet_c" {
  name       = "subnet-c"
  network_id = openstack_networking_network_v2.network_c.id
  cidr       = "10.20.0.0/26"
  ip_version = 4
}

# ===== РОУТЕР =====
resource "openstack_networking_router_v2" "main_router" {
  name           = "main-router"
  admin_state_up = true
}

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