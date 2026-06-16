# ===== КЛЮЧ =====
resource "openstack_compute_keypair_v2" "admin_key" {
  name       = "my-unique-key-2026"
  public_key = var.public_ssh_key
}

# ===== ВИРТУАЛЬНЫЕ МАШИНЫ =====
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