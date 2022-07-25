output "instance_ip_addr_gitlab" {
  value = "${yandex_compute_instance.ci-tutorial-gitlab.network_interface.0.nat_ip_address}"
}

output "instance_ip_addr_gitlab-runner" {
  value = "${yandex_compute_instance.gitlab-runner.network_interface.0.nat_ip_address}"
}