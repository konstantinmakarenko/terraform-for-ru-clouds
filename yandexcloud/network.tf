# Облачная сеть VPC
resource "yandex_vpc_network" "main" {
  name = "main-network"
}

# Подсеть A (сеть 10.10.0.0/18)
resource "yandex_vpc_subnet" "subnet_a" {
  name           = "subnet-a"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.network_a_cidr]
}

# Подсеть B (транзитная сеть 10.100.0.0/16)
resource "yandex_vpc_subnet" "subnet_b" {
  name           = "subnet-b"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.network_b_cidr]
}

# Подсеть C (сеть 10.20.0.0/26)
resource "yandex_vpc_subnet" "subnet_c" {
  name           = "subnet-c"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.network_c_cidr]
}

# NAT-шлюз для доступа в интернет (транзитная сеть B)
# В Yandex Cloud шлюз создаётся отдельно и привязывается к таблице маршрутизации
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

# Таблица маршрутизации для подсети B (для выхода в интернет через NAT-шлюз)
resource "yandex_vpc_route_table" "route_table_b" {
  name       = "route-table-b"
  network_id = yandex_vpc_network.main.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

# Привязываем таблицу маршрутизации к подсети B
# (это обеспечит маршрут по умолчанию для всех ВМ в этой подсети)
resource "yandex_vpc_subnet" "subnet_b_routed" {
  name           = "subnet-b"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.network_b_cidr]
  route_table_id = yandex_vpc_route_table.route_table_b.id
}