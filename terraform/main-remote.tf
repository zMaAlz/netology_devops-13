provider "yandex" {
  token = var.YC_TOKEN
  cloud_id  = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
  zone      = "ru-central1-a"
  }

locals { 
  vm_instans_name_platform = { 
    stage = { 
      "vm02" = { platform = "standard-v1", core_fraction = 5, cores = 2, memory = 2, size = 20 } 
     } 
    prod = {
    "vm02" = { platform = "standard-v2", core_fraction = 10, cores = 2, memory = 2, size = 40 } 
    "vm03" = { platform = "standard-v2", core_fraction = 10, cores = 2, memory = 2, size = 40 }
    } 
  } 
}

resource "yandex_vpc_network" "net" {
  name = "net" 
} 

resource "yandex_vpc_subnet" "subnet" {
  v4_cidr_blocks = ["192.168.1.0/24"]
  zone = "ru-central1-a"
  network_id = "${yandex_vpc_network.net.id}"
  name = "subnet"
}

resource "yandex_compute_instance" "vm_app" {
  for_each = local.vm_instans_name_platform[terraform.workspace]
  name = each.key
  resources {
    cores  = each.value.cores
    memory = each.value.memory
    core_fraction  = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = "fd879gb88170to70d38a"
      size = each.value.size
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet.id}"
 } 

  metadata = {
    ssh-keys = "${file("~/.ssh/id_rsa.pub")}"
  }
}

