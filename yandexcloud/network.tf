# ===== ДАННЫЕ ОБ ОБРАЗЕ =====
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts"
}

# Облачная сеть VPC
resource "yandex_vpc_network" "main" {
  name = "main-network"
}

# Подсеть A
resource "yandex_vpc_subnet" "subnet_a" {
  name           = "subnet-a"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.network_a_cidr]
}

# Подсеть C
resource "yandex_vpc_subnet" "subnet_c" {
  name           = "subnet-c"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.network_c_cidr]
}

# NAT-шлюз для доступа в интернет
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

# Таблица маршрутизации для подсети B
resource "yandex_vpc_route_table" "route_table_b" {
  name       = "route-table-b"
  network_id = yandex_vpc_network.main.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

# Подсеть B с таблицей маршрутизации (только один раз!)
resource "yandex_vpc_subnet" "subnet_b" {
  name           = "subnet-b"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.network_b_cidr]
  route_table_id = yandex_vpc_route_table.route_table_b.id

  depends_on = [
    yandex_vpc_route_table.route_table_b
  ]
}