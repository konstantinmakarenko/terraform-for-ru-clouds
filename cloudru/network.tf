# Создаём облачную сеть VPC
resource "cloudru_vpc_vpc" "main" {
  name = "main-vpc"
}
# Создаём подсети внутри сети main-vpc
resource "cloudru_compute_subnet" "subnet_a" {
  name        = "subnet-a"
  cidr        = var.network_a_cidr
  zone        = var.zone
  vpc_id      = cloudru_vpc_vpc.main.id
}
resource "cloudru_compute_subnet" "subnet_b" {
  name        = "subnet-b"
  cidr        = var.network_b_cidr
  zone        = var.zone
  vpc_id      = cloudru_vpc_vpc.main.id
}
resource "cloudru_compute_subnet" "subnet_c" {
  name        = "subnet-c"
  cidr        = var.network_c_cidr
  zone        = var.zone
  vpc_id      = cloudru_vpc_vpc.main.id
}
# Создаём NAT-шлюз и правило SNAT для доступа в интернет из подсети B
resource "cloudru_compute_nat_gateway" "nat_gateway" {
  name   = "nat-gateway"
  vpc_id = cloudru_vpc_vpc.main.id
  spec   = "Small"
}
resource "cloudru_compute_snat_rule" "nat_rule" {
  nat_gateway_id = cloudru_compute_nat_gateway.nat_gateway.id
  source_subnet_id = cloudru_compute_subnet.subnet_b.id
  floating_ip_id   = cloudru_compute_floating_ip.nat_ip.id
}
resource "cloudru_compute_floating_ip" "nat_ip" {
  pool = "public"
}