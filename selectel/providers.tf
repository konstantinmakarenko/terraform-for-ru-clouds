terraform {
  required_version = ">= 1.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 2.1.0"
    }
    selectel = {
      source  = "selectel/selectel"
      version = "~> 7.1.0"
    }
  }
}

# Провайдер Selectel используется для создания публичного IP-адреса для ws11.
provider "selectel" {
  # Данные для аутентификации передаются через переменные окружения или variables.
  # В данном случае используются переменные.
  domain_name = var.account_id      # Номер вашего аккаунта Selectel
  username    = var.service_user    # Имя сервисного пользователя
  password    = var.service_password
  auth_url    = "https://cloud.api.selcloud.ru/identity/v3/"
  auth_region = var.region
}

# OpenStack провайдер используется для создания всех остальных ресурсов:
# сетей, серверов, маршрутизации.
provider "openstack" {
  auth_url    = "https://cloud.api.selcloud.ru/identity/v3"
  domain_name = var.account_id
  tenant_id   = var.project_id       # ID вашего OpenStack-проекта
  user_name   = var.service_user
  password    = var.service_password
  region      = var.region
}