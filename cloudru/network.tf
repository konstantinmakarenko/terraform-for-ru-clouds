# Terraform-конфигурация этого файла описывает часть облачной инфраструктуры.


# Берём актуальный образ Ubuntu для виртуальных машин.
data "cloudru_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts"
  latest = true
}

# Создаём облачную сеть.
resource "cloudru_vpc_vpc" "main" {
  name = "main-vpc"
}

# Описываем подсеть и её адресный диапазон.
resource "cloudru_compute_subnet" "subnet_a" {
  name   = "subnet-a"
  cidr   = var.network_a_cidr
  zone   = var.zone
  vpc_id = cloudru_vpc_vpc.main.id
}

# Описываем подсеть и её адресный диапазон.
resource "cloudru_compute_subnet" "subnet_b" {
  name   = "subnet-b"
  cidr   = var.network_b_cidr
  zone   = var.zone
  vpc_id = cloudru_vpc_vpc.main.id
}

# Описываем подсеть и её адресный диапазон.
resource "cloudru_compute_subnet" "subnet_c" {
  name   = "subnet-c"
  cidr   = var.network_c_cidr
  zone   = var.zone
  vpc_id = cloudru_vpc_vpc.main.id
}
