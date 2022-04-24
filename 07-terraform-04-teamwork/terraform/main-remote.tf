provider "yandex" {
  token = var.YC_TOKEN
  cloud_id  = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
  zone      = "ru-central1-a"
}

#for_each = toset(["one", "two", "three"])


module "module_network" {
  source  = "./module/module_network"  
}


module "module_server" {
  count = 3
  source  = "./module/module_server"
#  name = "vm-${each.key}"
  network_interface {
    subnet_id = var.subnet_id
}
  metadata = {
    ssh-keys = "${file("~/.ssh/id_rsa.pub")}"
  }
}
