# Terraform-конфигурация этого файла описывает часть облачной инфраструктуры.


# Берём актуальный образ Ubuntu для виртуальных машин.
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts"
}

# Создаём облачную сеть.
resource "yandex_vpc_network" "main" {
  name = "main-network"
}

# Описываем подсеть и её адресный диапазон.
resource "yandex_vpc_subnet" "subnet_a" {
  name           = "subnet-a"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.network_a_cidr]
}

# Описываем подсеть и её адресный диапазон.
resource "yandex_vpc_subnet" "subnet_c" {
  name           = "subnet-c"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.network_c_cidr]
}

# Настраиваем маршрутизацию между сетями.
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

# Настраиваем маршрутизацию между сетями.
resource "yandex_vpc_route_table" "route_table_b" {
  name       = "route-table-b"
  network_id = yandex_vpc_network.main.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

# Описываем подсеть и её адресный диапазон.
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
