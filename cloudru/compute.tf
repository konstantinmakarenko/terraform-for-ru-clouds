# Загружаем последнюю версию официального образа Ubuntu 24.04
data "cloudru_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts"
  latest = true
}
# Создаём маршрутизатор r1 с двумя сетевыми интерфейсами
resource "cloudru_compute_vm" "r1" {
  name        = "r1"
  zone        = var.zone
  image_id    = data.cloudru_compute_image.ubuntu.id
  flavor_name = "s7n.medium-2"
  ssh_keys    = [var.public_ssh_key]
  user_data   = base64encode(<<-EOF
    #!/bin/bash
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p
  EOF
  )
  network_interface {
    subnet_id     = cloudru_compute_subnet.subnet_a.id
    ip_address    = "10.10.0.1"
    security_group_ids = []
  }
  network_interface {
    subnet_id     = cloudru_compute_subnet.subnet_b.id
    ip_address    = "10.100.0.11"
    security_group_ids = []
  }
  boot_disk {
    size = 15
    type = "ssd"
  }
}
# Маршрутизатор r2
resource "cloudru_compute_vm" "r2" {
  name        = "r2"
  zone        = var.zone
  image_id    = data.cloudru_compute_image.ubuntu.id
  flavor_name = "s7n.medium-2"
  ssh_keys    = [var.public_ssh_key]
  user_data   = base64encode(<<-EOF
    #!/bin/bash
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p
  EOF
  )
  network_interface {
    subnet_id     = cloudru_compute_subnet.subnet_b.id
    ip_address    = "10.100.0.12"
    security_group_ids = []
  }
  network_interface {
    subnet_id     = cloudru_compute_subnet.subnet_c.id
    ip_address    = "10.20.0.1"
    security_group_ids = []
  }
  boot_disk {
    size = 15
    type = "ssd"
  }
}
# Клиент ws11 с публичным IP
resource "cloudru_compute_vm" "ws11" {
  name        = "ws11"
  zone        = var.zone
  image_id    = data.cloudru_compute_image.ubuntu.id
  flavor_name = "s7n.medium-2"
  ssh_keys    = [var.public_ssh_key]
  user_data   = base64encode(<<-EOF
    #!/bin/bash
    ip route add default via 10.10.0.1 dev eth0 || true
    ip route add 10.20.0.0/26 via 10.100.0.12 dev eth0 || true
  EOF
  )
  network_interface {
    subnet_id = cloudru_compute_subnet.subnet_a.id
    ip_address = "10.10.0.2"
  }
  boot_disk {
    size = 15
    type = "ssd"
  }
}
# Выделяем публичный IP для ws11 (Вариант А)
resource "cloudru_compute_floating_ip" "ws11_floating_ip" {
  pool = "public"
}
resource "cloudru_compute_floating_ip_associate" "ws11_floating_ip_assoc" {
  floating_ip_id = cloudru_compute_floating_ip.ws11_floating_ip.id
  instance_id    = cloudru_compute_vm.ws11.id
}
# Клиент ws21
resource "cloudru_compute_vm" "ws21" {
  name        = "ws21"
  zone        = var.zone
  image_id    = data.cloudru_compute_image.ubuntu.id
  flavor_name = "s7n.medium-2"
  ssh_keys    = [var.public_ssh_key]
  user_data   = base64encode(<<-EOF
    #!/bin/bash
    ip route add default via 10.20.0.1 dev eth0 || true
  EOF
  )
  network_interface {
    subnet_id = cloudru_compute_subnet.subnet_c.id
    ip_address = "10.20.0.10"
  }
  boot_disk {
    size = 15
    type = "ssd"
  }
}
# Клиент ws22
resource "cloudru_compute_vm" "ws22" {
  name        = "ws22"
  zone        = var.zone
  image_id    = data.cloudru_compute_image.ubuntu.id
  flavor_name = "s7n.medium-2"
  ssh_keys    = [var.public_ssh_key]
  user_data   = base64encode(<<-EOF
    #!/bin/bash
    ip route add default via 10.20.0.1 dev eth0 || true
  EOF
  )
  network_interface {
    subnet_id = cloudru_compute_subnet.subnet_c.id
    ip_address = "10.20.0.20"
  }
  boot_disk {
    size = 15
    type = "ssd"
  }
}