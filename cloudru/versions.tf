terraform {
  required_version = ">= 1.0"
  required_providers {
    cloudru = {
      source  = "C:/Users/kmoms/portfolio/normal/terraform-for-ru-clouds/cloudru/terraform/providers"
      version = "2.0.2"
    }
  }
}

provider "cloudru" {
  auth_key_id = var.auth_key_id
  auth_secret = var.auth_secret
  project_id  = var.project_id
}