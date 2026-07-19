# Terraform-конфигурация этого файла описывает сетевую часть стенда Cloud.ru.

# Создаём VPC для всех подсетей учебного стенда.
resource "cloudru_evolution_vpc_vpc" "main" {
  project_id  = var.project_id
  name        = "main-vpc"
  description = "VPC для учебного стенда"
}

# Подсеть A используется для ws11 и первого интерфейса r1.
resource "cloudru_evolution_compute_subnet" "subnet_a" {
  project_id = var.project_id
  name       = "subnet-a"
  zone_identifier = {
    name = var.zone
  }
  description    = "Подсеть A"
  subnet_address = var.network_a_cidr
  routed_network = true
  default        = false
  vpc_id         = cloudru_evolution_vpc_vpc.main.id
  dns_servers = {
    value = ["8.8.4.4", "8.8.8.8"]
  }
}

# Подсеть B связывает маршрутизаторы r1 и r2.
resource "cloudru_evolution_compute_subnet" "subnet_b" {
  project_id = var.project_id
  name       = "subnet-b"
  zone_identifier = {
    name = var.zone
  }
  description    = "Подсеть B"
  subnet_address = var.network_b_cidr
  routed_network = true
  default        = false
  vpc_id         = cloudru_evolution_vpc_vpc.main.id
  dns_servers = {
    value = ["8.8.4.4", "8.8.8.8"]
  }
}

# Подсеть C используется для r2, ws21 и ws22.
resource "cloudru_evolution_compute_subnet" "subnet_c" {
  project_id = var.project_id
  name       = "subnet-c"
  zone_identifier = {
    name = var.zone
  }
  description    = "Подсеть C"
  subnet_address = var.network_c_cidr
  routed_network = true
  default        = false
  vpc_id         = cloudru_evolution_vpc_vpc.main.id
  dns_servers = {
    value = ["8.8.4.4", "8.8.8.8"]
  }
}

# Группа безопасности разрешает базовый доступ к виртуальным машинам.
resource "cloudru_evolution_compute_security_group" "allow_ssh" {
  project_id = var.project_id
  name       = "allow-ssh"
  zone_identifier = {
    name = var.zone
  }
  description = "SSH-доступ к стенду"
}

# Открываем SSH для подключения к стенду.
resource "cloudru_evolution_compute_security_group_rule" "ingress_ssh" {
  security_group_id = cloudru_evolution_compute_security_group.allow_ssh.id
  direction         = "TRAFFIC_DIRECTION_INGRESS"
  ether_type        = "ETHER_TYPE_IPV4"
  ip_protocol       = "IP_PROTOCOL_TCP"
  port_range        = "22:22"
  description       = "SSH-доступ"
  remote_ip_prefix  = "0.0.0.0/0"
}

# Разрешаем исходящий TCP-трафик с виртуальных машин.
resource "cloudru_evolution_compute_security_group_rule" "egress_tcp" {
  security_group_id = cloudru_evolution_compute_security_group.allow_ssh.id
  direction         = "TRAFFIC_DIRECTION_EGRESS"
  ether_type        = "ETHER_TYPE_IPV4"
  ip_protocol       = "IP_PROTOCOL_TCP"
  port_range        = "1:65535"
  description       = "Исходящий TCP-трафик"
  remote_ip_prefix  = "0.0.0.0/0"
}