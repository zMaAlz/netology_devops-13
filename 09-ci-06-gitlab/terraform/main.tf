provider "yandex" {
  token = var.YC_TOKEN
  cloud_id  = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "network" {
  name = "net"
}

resource "yandex_vpc_subnet" "network-subnet" {
  v4_cidr_blocks = ["10.1.0.0/24"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.network.id}"
}

resource "yandex_kubernetes_cluster" "kuber" {
 network_id = "${yandex_vpc_network.network.id}"
 master {
   zonal {
     zone      = "${yandex_vpc_subnet.network-subnet.zone}"
     subnet_id = "${yandex_vpc_subnet.network-subnet.id}"
   }
   public_ip = true
  }
 service_account_id      = var.yc_service_account
 node_service_account_id = var.yc_service_account
}

resource "yandex_kubernetes_node_group" "kub-group" {
  cluster_id = yandex_kubernetes_cluster.kuber.id

  instance_template {
    platform_id = "standard-v1"

    resources {
      cores  = 2
      memory = 4
      core_fraction  = 5
    }

  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }
}

resource "yandex_compute_instance" "ci-tutorial-gitlab" {
  name = "ci-tutorial-gitlab"
  platform_id = "standard-v1"
  zone = "ru-central1-a"
  description = "netology gitlab"  

  boot_disk {
    initialize_params {
      image_id = "fd8jvc5l8gsftvulel9g"
      size = 50
    }
  }
  resources {
    cores  = 2
    memory = 4
    core_fraction = 100
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.network-subnet.id}"
    nat = true
  }

  metadata = {
    user-data = "${file("/home/maal/exchange/terraform/meta.txt")}"
   }
  allow_stopping_for_update = "true"
}

resource "yandex_container_registry" "netology-registry" {
  name = "netology-registry"
  folder_id = var.YC_FOLDER_ID
  labels = {
    my-label = "registry"
  }
}

resource "yandex_compute_instance" "gitlab-runner" {
  name = "gitlab-runner"
  platform_id = "standard-v1"
  zone = "ru-central1-a"
  description = "gitlab-runner"  

  boot_disk {
    initialize_params {
      image_id = "fd88d14a6790do254kj7"
      size = 20
    }
  }
  resources {
    cores  = 2
    memory = 2
  }
  network_interface {
    subnet_id = "${yandex_vpc_subnet.network-subnet.id}"
    nat = true
  }
  metadata = {
    user-data = "${file("/home/maal/exchange/terraform/meta.txt")}"
  }
}
