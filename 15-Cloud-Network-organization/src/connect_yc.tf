terraform { 
  required_providers { 
    yandex = { 
      source = "terraform-registry.storage.yandexcloud.net/yandex-cloud/yandex"     
    } 
  }
  required_version = ">= 0.13"           

  backend "s3" {                             
    endpoint   = "storage.yandexcloud.net" 
    bucket     = "terraform-backet-ru" 
    region     = "ru-central1" 
    key        = "terraform.tfstate" 
    skip_region_validation      = true 
    skip_credentials_validation = true 
    } 
}

provider "yandex" {
  token = var.YC_TOKEN
  cloud_id  = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
  zone      = "ru-central1-a"
}
