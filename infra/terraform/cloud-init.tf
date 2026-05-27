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
    rh_subscription:
      activation-key: ${var.rhel_activation_key}
      org: ${var.rhel_organization}
    packages:
      - fail2ban
    package_update: true
    package_upgrade: true
    write_files:
      - path: /etc/ssh/sshd_config.d/ssh-hardening.conf
        content: |
          PermitRootLogin no
          PasswordAuthentication no
          Port 22
          KbdInteractiveAuthentication no
          ChallengeResponseAuthentication no
          MaxAuthTries 2
          AllowTcpForwarding no
          X11Forwarding no
          AllowAgentForwarding no
          AuthorizedKeysFile .ssh/authorized_keys
          AllowUsers kanna
    runcmd:
      - printf "[sshd]\nenabled = true\nport = ssh, 22\nbanaction = iptables-multiport" > /etc/fail2ban/jail.local
      - systemctl enable fail2ban
      - semanage port -a -t ssh_port_t -p tcp 22
      - reboot
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