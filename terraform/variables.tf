###cloud vars

variable "cloud_id" {
  type        = string
  default     = "b1g0bcbge4leskva6q64"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default = "b1gm8a6tiffresiiosuj"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "k8s_network" {
  type        = string
  default     = "k8s-network"
  description = "K8S network name"
}

variable "k8s_subnet" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "K8S CIDR"
}

variable "k8s_master_node_count" {
  type        = number
  default     = 1
  validation {
    condition     = var.k8s_master_node_count >= 1
    error_message = "Должна быть хотя бы одна master-нода."
  }
  description = "Количество master-нод кластера"
}

variable "k8s_worker_node_count" {
  type        = number
  default     = 4
  description = "Количество worker-нод кластера"
}

variable "vm_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "VM image family for K8S nodes"
}

variable "vm_preemptible" {
  type        = bool
  default     = true
  description = "VM preemptible flag"
}

variable "vm_nat" {
  type        = bool
  default     = true
  description = "VM NAT flag"
}

variable "vm_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "VM platform ID"
}

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    disk_size     = number
  }))
}

variable "vm_user" {
  description = "VM user"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key_path" {
  description = "SSH public key path"
  type        = string
  default     = "~/.ssh/yc_ed25519.pub"
}

