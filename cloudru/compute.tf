# Terraform-конфигурация этого файла описывает виртуальные машины Cloud.ru.

locals {
  vm_names = ["r1", "r2", "ws11", "ws21", "ws22"]
}

# Интерфейсы сохраняют исходную схему подключения ВМ к подсетям.
resource "cloudru_evolution_compute_interface" "r1_a" {
  project_id = var.project_id
  name       = "r1-a"
  zone_identifier = {
    name = var.zone
  }
  description                = "Интерфейс r1 в подсети A"
  subnet_id                  = cloudru_evolution_compute_subnet.subnet_a.id
  interface_security_enabled = true
  security_groups_identifiers = {
    value = [{ id = cloudru_evolution_compute_security_group.allow_ssh.id }]
  }
  type = "INTERFACE_TYPE_REGULAR"
}

resource "cloudru_evolution_compute_interface" "r1_b" {
  project_id = var.project_id
  name       = "r1-b"
  zone_identifier = {
    name = var.zone
  }
  description                = "Интерфейс r1 в подсети B"
  subnet_id                  = cloudru_evolution_compute_subnet.subnet_b.id
  interface_security_enabled = true
  security_groups_identifiers = {
    value = [{ id = cloudru_evolution_compute_security_group.allow_ssh.id }]
  }
  type = "INTERFACE_TYPE_REGULAR"
}

resource "cloudru_evolution_compute_interface" "r2_b" {
  project_id = var.project_id
  name       = "r2-b"
  zone_identifier = {
    name = var.zone
  }
  description                = "Интерфейс r2 в подсети B"
  subnet_id                  = cloudru_evolution_compute_subnet.subnet_b.id
  interface_security_enabled = true
  security_groups_identifiers = {
    value = [{ id = cloudru_evolution_compute_security_group.allow_ssh.id }]
  }
  type = "INTERFACE_TYPE_REGULAR"
}

resource "cloudru_evolution_compute_interface" "r2_c" {
  project_id = var.project_id
  name       = "r2-c"
  zone_identifier = {
    name = var.zone
  }
  description                = "Интерфейс r2 в подсети C"
  subnet_id                  = cloudru_evolution_compute_subnet.subnet_c.id
  interface_security_enabled = true
  security_groups_identifiers = {
    value = [{ id = cloudru_evolution_compute_security_group.allow_ssh.id }]
  }
  type = "INTERFACE_TYPE_REGULAR"
}

resource "cloudru_evolution_compute_interface" "ws11" {
  project_id = var.project_id
  name       = "ws11"
  zone_identifier = {
    name = var.zone
  }
  description                = "Интерфейс ws11 в подсети A"
  subnet_id                  = cloudru_evolution_compute_subnet.subnet_a.id
  interface_security_enabled = true
  security_groups_identifiers = {
    value = [{ id = cloudru_evolution_compute_security_group.allow_ssh.id }]
  }
  type = "INTERFACE_TYPE_REGULAR"

  external_ip_specs = {
    new_external_ip = true
  }
}

resource "cloudru_evolution_compute_interface" "ws21" {
  project_id = var.project_id
  name       = "ws21"
  zone_identifier = {
    name = var.zone
  }
  description                = "Интерфейс ws21 в подсети C"
  subnet_id                  = cloudru_evolution_compute_subnet.subnet_c.id
  interface_security_enabled = true
  security_groups_identifiers = {
    value = [{ id = cloudru_evolution_compute_security_group.allow_ssh.id }]
  }
  type = "INTERFACE_TYPE_REGULAR"
}

resource "cloudru_evolution_compute_interface" "ws22" {
  project_id = var.project_id
  name       = "ws22"
  zone_identifier = {
    name = var.zone
  }
  description                = "Интерфейс ws22 в подсети C"
  subnet_id                  = cloudru_evolution_compute_subnet.subnet_c.id
  interface_security_enabled = true
  security_groups_identifiers = {
    value = [{ id = cloudru_evolution_compute_security_group.allow_ssh.id }]
  }
  type = "INTERFACE_TYPE_REGULAR"
}

# Для каждой ВМ создаём отдельный загрузочный диск.
resource "cloudru_evolution_compute_disk" "boot" {
  for_each   = toset(local.vm_names)
  project_id = var.project_id
  name       = "${each.key}-boot"
  size       = var.boot_disk_size
  zone_identifier = {
    name = var.zone
  }
  disk_type_identifier = {
    name = var.disk_type
  }
  description = "Загрузочный диск ${each.key}"
  bootable    = true
  image_id    = var.image_id
  encrypted   = false
  readonly    = false
  shared      = false
}

# Маршрутизатор r1 соединяет подсети A и B.
resource "cloudru_evolution_compute_vm" "r1" {
  project_id = var.project_id
  name       = "r1"
  zone_identifier = {
    name = var.zone
  }
  flavor_identifier = {
    name = var.flavor
  }
  description = "Маршрутизатор r1"
  disk_identifiers = [{
    disk_id = cloudru_evolution_compute_disk.boot["r1"].id
  }]
  network_interfaces = [
    { interface_id = cloudru_evolution_compute_interface.r1_a.id },
    { interface_id = cloudru_evolution_compute_interface.r1_b.id }
  ]
  cloud_init_userdata = base64encode(<<-EOF
    #!/bin/bash
    mkdir -p /home/ubuntu/.ssh
    echo "${var.public_ssh_key}" > /home/ubuntu/.ssh/authorized_keys
    chmod 700 /home/ubuntu/.ssh
    chmod 600 /home/ubuntu/.ssh/authorized_keys
    chown -R ubuntu:ubuntu /home/ubuntu/.ssh
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p
  EOF
  )
}

# Маршрутизатор r2 соединяет подсети B и C.
resource "cloudru_evolution_compute_vm" "r2" {
  project_id = var.project_id
  name       = "r2"
  zone_identifier = {
    name = var.zone
  }
  flavor_identifier = {
    name = var.flavor
  }
  description = "Маршрутизатор r2"
  disk_identifiers = [{
    disk_id = cloudru_evolution_compute_disk.boot["r2"].id
  }]
  network_interfaces = [
    { interface_id = cloudru_evolution_compute_interface.r2_b.id },
    { interface_id = cloudru_evolution_compute_interface.r2_c.id }
  ]
  cloud_init_userdata = base64encode(<<-EOF
    #!/bin/bash
    mkdir -p /home/ubuntu/.ssh
    echo "${var.public_ssh_key}" > /home/ubuntu/.ssh/authorized_keys
    chmod 700 /home/ubuntu/.ssh
    chmod 600 /home/ubuntu/.ssh/authorized_keys
    chown -R ubuntu:ubuntu /home/ubuntu/.ssh
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p
  EOF
  )
}

# Рабочая станция ws11 получает публичный IP через интерфейс Cloud.ru.
resource "cloudru_evolution_compute_vm" "ws11" {
  project_id = var.project_id
  name       = "ws11"
  zone_identifier = {
    name = var.zone
  }
  flavor_identifier = {
    name = var.flavor
  }
  description = "Рабочая станция ws11"
  disk_identifiers = [{
    disk_id = cloudru_evolution_compute_disk.boot["ws11"].id
  }]
  network_interfaces = [{
    interface_id = cloudru_evolution_compute_interface.ws11.id
  }]
  cloud_init_userdata = base64encode(<<-EOF
    #!/bin/bash
    mkdir -p /home/ubuntu/.ssh
    echo "${var.public_ssh_key}" > /home/ubuntu/.ssh/authorized_keys
    chmod 700 /home/ubuntu/.ssh
    chmod 600 /home/ubuntu/.ssh/authorized_keys
    chown -R ubuntu:ubuntu /home/ubuntu/.ssh
    ip route add default via 10.10.0.1 dev eth0 || true
    ip route add 10.20.0.0/26 via 10.100.0.12 dev eth0 || true
  EOF
  )
}

# Рабочая станция ws21 подключается к подсети C.
resource "cloudru_evolution_compute_vm" "ws21" {
  project_id = var.project_id
  name       = "ws21"
  zone_identifier = {
    name = var.zone
  }
  flavor_identifier = {
    name = var.flavor
  }
  description = "Рабочая станция ws21"
  disk_identifiers = [{
    disk_id = cloudru_evolution_compute_disk.boot["ws21"].id
  }]
  network_interfaces = [{
    interface_id = cloudru_evolution_compute_interface.ws21.id
  }]
  cloud_init_userdata = base64encode(<<-EOF
    #!/bin/bash
    mkdir -p /home/ubuntu/.ssh
    echo "${var.public_ssh_key}" > /home/ubuntu/.ssh/authorized_keys
    chmod 700 /home/ubuntu/.ssh
    chmod 600 /home/ubuntu/.ssh/authorized_keys
    chown -R ubuntu:ubuntu /home/ubuntu/.ssh
    ip route add default via 10.20.0.1 dev eth0 || true
  EOF
  )
}

# Рабочая станция ws22 подключается к подсети C.
resource "cloudru_evolution_compute_vm" "ws22" {
  project_id = var.project_id
  name       = "ws22"
  zone_identifier = {
    name = var.zone
  }
  flavor_identifier = {
    name = var.flavor
  }
  description = "Рабочая станция ws22"
  disk_identifiers = [{
    disk_id = cloudru_evolution_compute_disk.boot["ws22"].id
  }]
  network_interfaces = [{
    interface_id = cloudru_evolution_compute_interface.ws22.id
  }]
  cloud_init_userdata = base64encode(<<-EOF
    #!/bin/bash
    mkdir -p /home/ubuntu/.ssh
    echo "${var.public_ssh_key}" > /home/ubuntu/.ssh/authorized_keys
    chmod 700 /home/ubuntu/.ssh
    chmod 600 /home/ubuntu/.ssh/authorized_keys
    chown -R ubuntu:ubuntu /home/ubuntu/.ssh
    ip route add default via 10.20.0.1 dev eth0 || true
  EOF
  )
}