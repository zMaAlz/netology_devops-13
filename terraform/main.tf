provider "yandex" {
  token = var.YC_TOKEN 
# service_account_key_file = var.YC_SERVICE_ACCOUNT_KEY_FILE
  cloud_id  = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "vm-net" {
  name = "net"
}

resource "yandex_vpc_subnet" "vm-subnet" {
  v4_cidr_blocks = ["10.1.0.0/24"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.vm-net.id}"
}

resource "yandex_compute_instance" "vm-1" {
  name = "vm-1"
  platform_id = "standard-v1"
  zone = "ru-central1-a"
  description = "netology test vm"  

  boot_disk {
    initialize_params {
      image_id = "fd879gb88170to70d38a"
      size = 40
    }
  }
  resources {
    cores  = 2
    memory = 2
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.vm-subnet.id}"
  }
  metadata = {
    ssh-keys = "${file("~/.ssh/id_rsa.pub")}"
  }
  allow_stopping_for_update = "true"
}

