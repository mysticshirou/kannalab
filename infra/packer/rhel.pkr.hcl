packer {
  required_plugins {
    name = {
      version = "~> 1"
      source = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "rhel-template" {
  proxmox_url = var.proxmox_url
  username = var.proxmox_username
  password = var.proxmox_password
  node = var.proxmox_node
  insecure_skip_tls_verify = true

  http_directory = var.http_server

  vm_name = "rhel-template"
  vm_id = 999

  template_name = "rhel-template"
  template_description = "Red Hat Enterprise Linux template"

  memory = 4096
  cores = 4
  sockets = 1
  cpu_type = "host"

  qemu_agent = true
  scsi_controller = "virtio-scsi-single"

  boot_iso {
    type = "scsi"
    iso_file = "local:iso/rhel-10.2-x86_64-boot.iso"
    unmount = true
    iso_checksum = "sha256:675001a587c15f0c56c09beca6b1576c3be63cc4a0754e375ce93a6afda3dc8a"
  }

  disks {
    type = "scsi"
    disk_size = "100G"
    storage_pool = "local-lvm"
    storage_pool_type = "lvm"
  }

  network_adapters {
    model = "virtio"
    bridge = "vmbr0"
    firewall = true
  }

  boot_wait = "10s"
  boot_command = ["<up>e<down><down><end> ip=dhcp inst.cmdline inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg rhsm_password_server=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rhsm-password.yml <leftCtrlOn>x<leftCtrlOff>"]

  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout = "15m"
}

build {
  sources = ["source.proxmox-iso.rhel-template"]
}