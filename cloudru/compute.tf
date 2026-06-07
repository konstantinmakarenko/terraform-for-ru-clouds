# ===== МАРШРУТИЗАТОР r1 =====
resource "cloudru_compute_vm" "r1" {
  name        = "r1"
  zone        = var.zone
  image_id    = data.cloudru_compute_image.ubuntu.id
  flavor_name = "s7n.medium-2"
  ssh_keys    = [var.public_ssh_key]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p
  EOF
  )

  network_interface {
    subnet_id  = cloudru_compute_subnet.subnet_a.id
    ip_address = "10.10.0.1"
  }

  network_interface {
    subnet_id  = cloudru_compute_subnet.subnet_b.id
    ip_address = "10.100.0.11"
  }
}

# ===== МАРШРУТИЗАТОР r2 =====
resource "cloudru_compute_vm" "r2" {
  name        = "r2"
  zone        = var.zone
  image_id    = data.cloudru_compute_image.ubuntu.id
  flavor_name = "s7n.medium-2"
  ssh_keys    = [var.public_ssh_key]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p
  EOF
  )

  network_interface {
    subnet_id  = cloudru_compute_subnet.subnet_b.id
    ip_address = "10.100.0.12"
  }

  network_interface {
    subnet_id  = cloudru_compute_subnet.subnet_c.id
    ip_address = "10.20.0.1"
  }
}

# ===== РАБОЧАЯ СТАНЦИЯ ws11 =====
resource "cloudru_compute_vm" "ws11" {
  name        = "ws11"
  zone        = var.zone
  image_id    = data.cloudru_compute_image.ubuntu.id
  flavor_name = "s7n.medium-2"
  ssh_keys    = [var.public_ssh_key]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    ip route add default via 10.10.0.1 dev eth0 || true
    ip route add 10.20.0.0/26 via 10.100.0.12 dev eth0 || true
  EOF
  )

  network_interface {
    subnet_id  = cloudru_compute_subnet.subnet_a.id
    ip_address = "10.10.0.2"
  }
}

# ===== ПУБЛИЧНЫЙ IP ДЛЯ ws11 =====
resource "cloudru_compute_floating_ip" "ws11_floating_ip" {}

resource "cloudru_compute_floating_ip_associate" "ws11_floating_ip_assoc" {
  floating_ip_id = cloudru_compute_floating_ip.ws11_floating_ip.id
  instance_id    = cloudru_compute_vm.ws11.id
}

# ===== РАБОЧАЯ СТАНЦИЯ ws21 =====
resource "cloudru_compute_vm" "ws21" {
  name        = "ws21"
  zone        = var.zone
  image_id    = data.cloudru_compute_image.ubuntu.id
  flavor_name = "s7n.medium-2"
  ssh_keys    = [var.public_ssh_key]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    ip route add default via 10.20.0.1 dev eth0 || true
  EOF
  )

  network_interface {
    subnet_id  = cloudru_compute_subnet.subnet_c.id
    ip_address = "10.20.0.10"
  }
}

# ===== РАБОЧАЯ СТАНЦИЯ ws22 =====
resource "cloudru_compute_vm" "ws22" {
  name        = "ws22"
  zone        = var.zone
  image_id    = data.cloudru_compute_image.ubuntu.id
  flavor_name = "s7n.medium-2"
  ssh_keys    = [var.public_ssh_key]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    ip route add default via 10.20.0.1 dev eth0 || true
  EOF
  )

  network_interface {
    subnet_id  = cloudru_compute_subnet.subnet_c.id
    ip_address = "10.20.0.20"
  }
}