# SSH-ключ для доступа к ВМ
resource "yandex_compute_keypair" "admin_key" {
  name       = "admin-key"
  public_key = var.public_ssh_key
}

# === Маршрутизатор r1 ===
resource "yandex_compute_instance" "r1" {
  name        = "r1"
  platform_id = "standard-v2"
  zone        = var.default_zone

  resources {
    cores         = 1
    memory        = 1   # 1 GB RAM
    core_fraction = 20  # 20% гарантии vCPU (соответствует ~10%)
  }

  boot_disk {
    initialize_params {
      image_family = "ubuntu-2404-lts"  # Ubuntu 24.04 LTS
      size         = 15                  # 15 GB
      type         = "network-ssd"
    }
  }

  # Интерфейс в сети A (адрес будет назначен автоматически из пула подсети)
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_a.id
    nat       = false  # Без публичного IP
  }

  # Интерфейс в транзитной сети B
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_b_routed.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_ssh_key}"
  }

  # Включаем IP forwarding для маршрутизации
  user_data = <<-EOF
    #!/bin/bash
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p
    EOF
}

# === Маршрутизатор r2 ===
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
      image_family = "ubuntu-2404-lts"
      size         = 15
      type         = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_b_routed.id
    nat       = false
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_c.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_ssh_key}"
  }

  user_data = <<-EOF
    #!/bin/bash
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p
    EOF
}

# === Рабочая станция ws11 ===
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
      image_family = "ubuntu-2404-lts"
      size         = 15
      type         = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_a.id
    nat       = true   # Публичный IP (Вариант А — прямой доступ из интернета)
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_ssh_key}"
  }

  # Маршрут по умолчанию через r1 (10.10.0.1)
  # В Yandex Cloud маршрутизатор не управляет трафиком между подсетями автоматически.
  # Настроим статический маршрут через user_data.
  user_data = <<-EOF
    #!/bin/bash
    ip route add default via 10.10.0.1 dev eth0 || true
    # Также добавляем маршрут в сеть C через r1
    ip route add 10.20.0.0/26 via 10.100.0.12 dev eth0 || true
    EOF
}

# === Рабочая станция ws21 ===
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
      image_family = "ubuntu-2404-lts"
      size         = 15
      type         = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_c.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_ssh_key}"
  }

  user_data = <<-EOF
    #!/bin/bash
    ip route add default via 10.20.0.1 dev eth0 || true
    EOF
}

# === Рабочая станция ws22 ===
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
      image_family = "ubuntu-2404-lts"
      size         = 15
      type         = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_c.id
    nat       = false
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_ssh_key}"
  }

  user_data = <<-EOF
    #!/bin/bash
    ip route add default via 10.20.0.1 dev eth0 || true
    EOF
}