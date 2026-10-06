resource "yandex_vpc_network" "k8s" {
  name = var.k8s_network
}

resource "yandex_vpc_subnet" "k8s" {
  name           = "k8s-subnet"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.k8s.id
  v4_cidr_blocks = var.k8s_subnet
}

resource "yandex_vpc_security_group" "k8s" {
  name       = "k8s-sg"
  network_id = yandex_vpc_network.k8s.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol       = "TCP"
    port           = 6443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = var.k8s_subnet
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  cloud_init = file("${path.module}/cloud-init.yaml")
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_image_family
}


# Создание виртуальных машин для master нод кластера
resource "yandex_compute_instance" "master" {
  count       = var.k8s_master_node_count
  name        = "k8s-master-${count.index + 1}"
  hostname    = "k8s-master-${count.index + 1}"
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores         = var.vms_resources["master"].cores
    memory        = var.vms_resources["master"].memory
    core_fraction = var.vms_resources["master"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["master"].disk_size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.k8s.id
    nat                = var.vm_nat
    security_group_ids = [yandex_vpc_security_group.k8s.id]
  }

  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init.yaml",
      {
        vm_user        = var.vm_user
        ssh_public_key = file(var.ssh_public_key_path)
    })
  }

}

# Создание виртуальных машин для worker нod кластера
resource "yandex_compute_instance" "worker" {
  count       = var.k8s_worker_node_count
  name        = "k8s-worker-${count.index + 1}"
  hostname    = "k8s-worker-${count.index + 1}"
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores         = var.vms_resources["worker"].cores
    memory        = var.vms_resources["worker"].memory
    core_fraction = var.vms_resources["worker"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["worker"].disk_size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.k8s.id
    nat                = var.vm_nat
    security_group_ids = [yandex_vpc_security_group.k8s.id]
  }

  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init.yaml",
      {
        vm_user        = var.vm_user
        ssh_public_key = file(var.ssh_public_key_path)
    })
  }

}
