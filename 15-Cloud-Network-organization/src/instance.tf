resource "yandex_compute_instance" "nat-instance" {
  name        = "nat-instance"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    core_fraction = 5
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.lab-subnet-public.id}"
    ip_address = var.nat_instance_ip
    nat = true
  }

    metadata = {
        user-data = "${file("/home/maal/exchange/terraform/meta.txt")}"
    }
}

resource "yandex_compute_instance" "private-srv" {
  name        = "private-srv"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    core_fraction = 5
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8263gk7qeo9om378j1"
      size = 60
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.lab-subnet-private.id}"
  }

    metadata = {
        user-data = "${file("/home/maal/exchange/terraform/meta.txt")}"
    }
}

output "instance_ip_addr_private-srv" {
  value = "${yandex_compute_instance.private-srv.network_interface.0.ip_address}"
}

output "instance_ip_addr_nat-instance" {
  value = "${yandex_compute_instance.nat-instance.network_interface.0.nat_ip_address}"
}
