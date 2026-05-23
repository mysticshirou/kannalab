terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "~> 0.106.0"
    }
  }
}

provider "proxmox" {
  endpoint = "${var.proxmox_url}"
  username = "${var.proxmox_username}"
  password = "${var.proxmox_password}"
  insecure = true
}

resource "proxmox_virtual_environment_vm" "ursus" {
  name = "ursus"
  node_name = var.proxmox_node

  clone {
    vm_id = var.proxmox_rhel_template_id
  }

  agent {
    enabled = true
  }
}