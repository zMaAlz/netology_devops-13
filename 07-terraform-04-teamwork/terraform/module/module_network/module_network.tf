resource "yandex_vpc_network" "net" {
  name = "net"
}

resource "yandex_vpc_subnet" "subnet" {
  v4_cidr_blocks = ["192.168.1.0/24"]
  zone = "ru-central1-a"
  network_id = "${yandex_vpc_network.net.id}"
  name = "subnet"
}

output "network_id" {
  value = "${yandex_vpc_network.net.id}"
}

output "subnet_id" {
  value = "${yandex_vpc_subnet.subnet.id}"
}
