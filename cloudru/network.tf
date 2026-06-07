# Данные об образе Ubuntu 24.04
data "cloudru_compute_image" "ubuntu" {
  family = "ubuntu-2404-lts"
  latest = true
}

# Основная VPC сеть
resource "cloudru_vpc_vpc" "main" {
  name = "main-vpc"
}

# Подсеть A (10.10.0.0/18) - для ws11 и r1
resource "cloudru_compute_subnet" "subnet_a" {
  name   = "subnet-a"
  cidr   = var.network_a_cidr
  zone   = var.zone
  vpc_id = cloudru_vpc_vpc.main.id
}

# Подсеть B (10.100.0.0/16) - транзитная для r1 и r2
resource "cloudru_compute_subnet" "subnet_b" {
  name   = "subnet-b"
  cidr   = var.network_b_cidr
  zone   = var.zone
  vpc_id = cloudru_vpc_vpc.main.id
}

# Подсеть C (10.20.0.0/26) - для ws21, ws22 и r2
resource "cloudru_compute_subnet" "subnet_c" {
  name   = "subnet-c"
  cidr   = var.network_c_cidr
  zone   = var.zone
  vpc_id = cloudru_vpc_vpc.main.id
}