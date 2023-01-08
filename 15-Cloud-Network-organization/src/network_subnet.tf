
resource "yandex_vpc_network" "lab-network" {
  name = "lab-network"
}

resource "yandex_vpc_subnet" "lab-subnet-public" {
  v4_cidr_blocks = [var.subnet_public_cidr]
  zone = "ru-central1-a"
  network_id = "${yandex_vpc_network.lab-network.id}"
  name = "lab-subnet-public"
}

resource "yandex_vpc_subnet" "lab-subnet-private" {
  v4_cidr_blocks = [var.subnet_private_cidr]
  zone = "ru-central1-a"
  network_id = "${yandex_vpc_network.lab-network.id}"
  name = "lab-subnet-private"
  route_table_id = "${yandex_vpc_route_table.lab-route-table-private.id}"
}

resource "yandex_vpc_route_table" "lab-route-table-private" {
  network_id = "${yandex_vpc_network.lab-network.id}"
  name = "lab-route-table-private"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.nat_instance_ip
  }
}
