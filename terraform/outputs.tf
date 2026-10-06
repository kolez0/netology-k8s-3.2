output "master_public_ips" {
  value = yandex_compute_instance.master[*].network_interface[0].nat_ip_address
}

output "master_private_ips" {
  value = yandex_compute_instance.master[*].network_interface[0].ip_address
}

output "worker_public_ips" {
  value = yandex_compute_instance.worker[*].network_interface[0].nat_ip_address
}

output "worker_private_ips" {
  value = yandex_compute_instance.worker[*].network_interface[0].ip_address
}