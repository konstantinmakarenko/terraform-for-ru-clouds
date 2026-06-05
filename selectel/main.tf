terraform {
  required_version = ">= 1.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 2.1.0"
    }
    selectel = {
      source  = "selectel/selectel"
      version = "~> 7.1.0"
    }
  }
}

provider "selectel" {
  domain_name = var.account_id
  username    = var.service_user
  password    = var.service_password
  auth_url    = "https://cloud.api.selcloud.ru/identity/v3"
  region      = var.region
}

provider "openstack" {
  auth_url    = "https://cloud.api.selcloud.ru/identity/v3"
  domain_name = var.account_id
  tenant_id   = var.project_id
  user_name   = var.service_user
  password    = var.service_password
  region      = var.region
}

# ===== ДАННЫЕ ОБ ОБРАЗЕ =====
data "openstack_images_image_v2" "ubuntu" {
  name        = "Ubuntu 24.04 LTS 64-bit"
  most_recent = true
}

# ===== КЛЮЧ =====
resource "openstack_compute_keypair_v2" "admin_key" {
  name       = "my-unique-key-2026"
  public_key = var.public_ssh_key
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

# ===== ВИРТУАЛЬНЫЕ МАШИНЫ С VOLUME =====
resource "openstack_compute_instance_v2" "r1" {
  name        = "r1"
  flavor_name = "SL1.1-1024"
  key_pair    = openstack_compute_keypair_v2.admin_key.name

  block_device {
    uuid                  = data.openstack_images_image_v2.ubuntu.id
    source_type           = "image"
    volume_size           = 15
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = openstack_networking_network_v2.network_a.name
  }

  network {
    name = openstack_networking_network_v2.network_b.name
  }
}

resource "openstack_compute_instance_v2" "r2" {
  name        = "r2"
  flavor_name = "SL1.1-1024"
  key_pair    = openstack_compute_keypair_v2.admin_key.name

  block_device {
    uuid                  = data.openstack_images_image_v2.ubuntu.id
    source_type           = "image"
    volume_size           = 15
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = openstack_networking_network_v2.network_b.name
  }

  network {
    name = openstack_networking_network_v2.network_c.name
  }
}

resource "openstack_compute_instance_v2" "ws11" {
  name        = "ws11"
  flavor_name = "SL1.1-1024"
  key_pair    = openstack_compute_keypair_v2.admin_key.name

  block_device {
    uuid                  = data.openstack_images_image_v2.ubuntu.id
    source_type           = "image"
    volume_size           = 15
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = openstack_networking_network_v2.network_a.name
  }
}

resource "openstack_compute_instance_v2" "ws21" {
  name        = "ws21"
  flavor_name = "SL1.1-1024"
  key_pair    = openstack_compute_keypair_v2.admin_key.name

  block_device {
    uuid                  = data.openstack_images_image_v2.ubuntu.id
    source_type           = "image"
    volume_size           = 15
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = openstack_networking_network_v2.network_c.name
  }
}

resource "openstack_compute_instance_v2" "ws22" {
  name        = "ws22"
  flavor_name = "SL1.1-1024"
  key_pair    = openstack_compute_keypair_v2.admin_key.name

  block_device {
    uuid                  = data.openstack_images_image_v2.ubuntu.id
    source_type           = "image"
    volume_size           = 15
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = openstack_networking_network_v2.network_c.name
  }
}

# ===== ПУБЛИЧНЫЙ IP ДЛЯ WS11 =====
resource "selectel_vpc_floatingip_v2" "ws11_floatingip" {
  project_id = var.project_id
  region     = var.region
}

resource "openstack_networking_floatingip_associate_v2" "ws11_fip_assoc" {
  floating_ip = selectel_vpc_floatingip_v2.ws11_floatingip.floating_ip_address
  port_id     = openstack_compute_instance_v2.ws11.network[0].port
}

# ===== ВЫВОД =====
output "ws11_public_ip" {
  value = selectel_vpc_floatingip_v2.ws11_floatingip.floating_ip_address
}

output "ws11_private_ip" {
  value = openstack_compute_instance_v2.ws11.network[0].fixed_ip_v4
}

output "r1_ips" {
  value = {
    eth0 = openstack_compute_instance_v2.r1.network[0].fixed_ip_v4
    eth1 = openstack_compute_instance_v2.r1.network[1].fixed_ip_v4
  }
}

output "r2_ips" {
  value = {
    eth0 = openstack_compute_instance_v2.r2.network[0].fixed_ip_v4
    eth1 = openstack_compute_instance_v2.r2.network[1].fixed_ip_v4
  }
}

output "ws21_ip" {
  value = openstack_compute_instance_v2.ws21.network[0].fixed_ip_v4
}

output "ws22_ip" {
  value = openstack_compute_instance_v2.ws22.network[0].fixed_ip_v4
}