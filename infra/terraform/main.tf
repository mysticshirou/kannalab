terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "~> 0.106.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_url
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = true

  ssh {
    agent = true
    username = "root"
  }
}

resource "proxmox_virtual_environment_vm" "server" {
  for_each = var.servers

  name = each.key
  vm_id = each.value.id

  node_name = var.proxmox_node

  clone {
    vm_id = var.proxmox_rhel_template_id
  }

  agent {
    enabled = true
  }

  initialization {
    dns {
      servers = ["1.1.1.1", "8.8.8.8"]
    }

    ip_config {
      ipv4 {
        address = each.value.static_ip
        gateway = var.gateway
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config["${each.key}"].id
    meta_data_file_id = proxmox_virtual_environment_file.meta_data_cloud_config["${each.key}"].id
  }
}

output "server_ips" {
  value = {
    for key, vm in proxmox_virtual_environment_vm.server :
    key => flatten(vm.ipv4_addresses)
  }
}