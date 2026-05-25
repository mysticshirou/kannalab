data "local_file" "ssh_public_key" {
  filename = "ssh/id_ed25519.pub"
}

resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  for_each = var.servers

  content_type = "snippets"
  datastore_id = "local"
  node_name = var.proxmox_node

  source_raw {
    data = <<-EOF
    #cloud-config
    hostname: ${each.key}
    users:
      - name: kanna
        groups:
          - wheel
        shell: /bin/bash
        ssh_authorized_keys:
          - ${trimspace(data.local_file.ssh_public_key.content)}
        sudo: ALL=(ALL) NOPASSWD:ALL
    EOF

    file_name = "${each.key}-user-data-cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_file" "meta_data_cloud_config" {
  for_each = var.servers

  content_type = "snippets"
  datastore_id = "local"
  node_name = var.proxmox_node

  source_raw {
    data = <<-EOF
    #cloud-config
    local-hostname: ${each.key}
    EOF

    file_name = "${each.key}-meta-data-cloud-config.yaml"
  }
}