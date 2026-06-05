# Создаём SSH-ключ
resource "openstack_compute_keypair_v2" "admin_key" {
  name       = "admin-key"
  public_key = var.public_ssh_key
}

# ===== ПОРТЫ ДЛЯ ВМ =====
resource "openstack_networking_port_v2" "port_r1_eth0" {
  name       = "port-r1-eth0"
  network_id = openstack_networking_network_v2.network_a.id
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnet_a.id
    ip_address = "10.10.0.1"
  }
}

resource "openstack_networking_port_v2" "port_r1_eth1" {
  name       = "port-r1-eth1"
  network_id = openstack_networking_network_v2.network_b.id
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnet_b.id
    ip_address = "10.100.0.11"
  }
}

resource "openstack_networking_port_v2" "port_r2_eth0" {
  name       = "port-r2-eth0"
  network_id = openstack_networking_network_v2.network_b.id
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnet_b.id
    ip_address = "10.100.0.12"
  }
}

resource "openstack_networking_port_v2" "port_r2_eth1" {
  name       = "port-r2-eth1"
  network_id = openstack_networking_network_v2.network_c.id
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnet_c.id
    ip_address = "10.20.0.1"
  }
}

resource "openstack_networking_port_v2" "port_ws11_eth0" {
  name       = "port-ws11-eth0"
  network_id = openstack_networking_network_v2.network_a.id
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnet_a.id
    ip_address = "10.10.0.2"
  }
}

resource "openstack_networking_port_v2" "port_ws21_eth0" {
  name       = "port-ws21-eth0"
  network_id = openstack_networking_network_v2.network_c.id
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnet_c.id
    ip_address = "10.20.0.10"
  }
}

resource "openstack_networking_port_v2" "port_ws22_eth0" {
  name       = "port-ws22-eth0"
  network_id = openstack_networking_network_v2.network_c.id
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.subnet_c.id
    ip_address = "10.20.0.20"
  }
}

# ===== ВИРТУАЛЬНЫЕ МАШИНЫ =====
# Используем правильные имена flavors из вывода openstack flavor list
resource "openstack_compute_instance_v2" "r1" {
  name        = "r1"
  image_name  = "Ubuntu 24.04 LTS 64-bit"
  flavor_name = "SL2.1-1024-8"  # 1 vCPU, 1 GB RAM, 8 GB диск
  key_pair    = openstack_compute_keypair_v2.admin_key.name

  network {
    port = openstack_networking_port_v2.port_r1_eth0.id
  }

  network {
    port = openstack_networking_port_v2.port_r1_eth1.id
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p
    EOF
}

resource "openstack_compute_instance_v2" "r2" {
  name        = "r2"
  image_name  = "Ubuntu 24.04 LTS 64-bit"
  flavor_name = "SL2.1-1024-8"
  key_pair    = openstack_compute_keypair_v2.admin_key.name

  network {
    port = openstack_networking_port_v2.port_r2_eth0.id
  }

  network {
    port = openstack_networking_port_v2.port_r2_eth1.id
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p
    EOF
}

resource "openstack_compute_instance_v2" "ws11" {
  name        = "ws11"
  image_name  = "Ubuntu 24.04 LTS 64-bit"
  flavor_name = "SL2.1-1024-8"
  key_pair    = openstack_compute_keypair_v2.admin_key.name

  network {
    port = openstack_networking_port_v2.port_ws11_eth0.id
  }

  user_data = <<-EOF
    #!/bin/bash
    ip route add default via 10.10.0.1 dev eth0
    EOF
}

resource "openstack_compute_instance_v2" "ws21" {
  name        = "ws21"
  image_name  = "Ubuntu 24.04 LTS 64-bit"
  flavor_name = "SL2.1-1024-8"
  key_pair    = openstack_compute_keypair_v2.admin_key.name

  network {
    port = openstack_networking_port_v2.port_ws21_eth0.id
  }

  user_data = <<-EOF
    #!/bin/bash
    ip route add default via 10.20.0.1 dev eth0
    EOF
}

resource "openstack_compute_instance_v2" "ws22" {
  name        = "ws22"
  image_name  = "Ubuntu 24.04 LTS 64-bit"
  flavor_name = "SL2.1-1024-8"
  key_pair    = openstack_compute_keypair_v2.admin_key.name

  network {
    port = openstack_networking_port_v2.port_ws22_eth0.id
  }

  user_data = <<-EOF
    #!/bin/bash
    ip route add default via 10.20.0.1 dev eth0
    EOF
}

# ===== ПУБЛИЧНЫЙ IP ДЛЯ WS11 (ВАРИАНТ А) =====
resource "selectel_vpc_floatingip_v2" "ws11_floatingip" {
  project_id = var.project_id
  region     = var.region
}

resource "openstack_networking_floatingip_associate_v2" "ws11_fip_assoc" {
  floating_ip = selectel_vpc_floatingip_v2.ws11_floatingip.floating_ip_address
  port_id     = openstack_networking_port_v2.port_ws11_eth0.id
}