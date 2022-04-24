resource "yandex_compute_instance" "vm_app" {
  resources {
    cores  = 2
    memory = 4
    core_fraction  = 10
  }

  boot_disk {
    initialize_params {
      image_id = "fd879gb88170to70d38a"
      size = 50
    }
  }

  network_interface {
    subnet_id = var.subnet_id 
 }
}
