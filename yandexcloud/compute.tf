# === МАРШРУТИЗАТОР r1 ===
resource "yandex_compute_instance" "r1" {
  name        = "r1"
  platform_id = "standard-v2"
  zone        = var.default_zone

  resources {
    cores         = 1
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = 15
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_a.id
    nat       = false
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_b_routed.id  # Изменено
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_ssh_key}"
    user-data = <<-EOF
      #!/bin/bash
      echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
      sysctl -p
      EOF
  }
}

# === МАРШРУТИЗАТОР r2 ===
resource "yandex_compute_instance" "r2" {
  name        = "r2"
  platform_id = "standard-v2"
  zone        = var.default_zone

  resources {
    cores         = 1
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = 15
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_b_routed.id  # Изменено
    nat       = false
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_c.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_ssh_key}"
    user-data = <<-EOF
      #!/bin/bash
      echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
      sysctl -p
      EOF
  }
}

# === РАБОЧАЯ СТАНЦИЯ ws11 ===
resource "yandex_compute_instance" "ws11" {
  name        = "ws11"
  platform_id = "standard-v2"
  zone        = var.default_zone

  resources {
    cores         = 1
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = 15
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_a.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_ssh_key}"
    user-data = <<-EOF
      #!/bin/bash
      ip route add default via 10.10.0.1 dev eth0 || true
      ip route add 10.20.0.0/26 via 10.100.0.12 dev eth0 || true
      EOF
  }
}

# === РАБОЧАЯ СТАНЦИЯ ws21 ===
resource "yandex_compute_instance" "ws21" {
  name        = "ws21"
  platform_id = "standard-v2"
  zone        = var.default_zone

  resources {
    cores         = 1
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = 15
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_c.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_ssh_key}"
    user-data = <<-EOF
      #!/bin/bash
      ip route add default via 10.20.0.1 dev eth0 || true
      EOF
  }
}

# === РАБОЧАЯ СТАНЦИЯ ws22 ===
resource "yandex_compute_instance" "ws22" {
  name        = "ws22"
  platform_id = "standard-v2"
  zone        = var.default_zone

  resources {
    cores         = 1
    memory        = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = 15
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_c.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_ssh_key}"
    user-data = <<-EOF
      #!/bin/bash
      ip route add default via 10.20.0.1 dev eth0 || true
      EOF
  }
}