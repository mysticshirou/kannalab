variable "proxmox_url" {
  type = string
}

variable "proxmox_username" {
  type = string
}

variable "proxmox_node" {
  type = string
}

variable "proxmox_password" {
  type = string
  sensitive = true
}

variable "proxmox_rhel_template_id" {
  type = number
}

variable "servers" {
  type = map(object({
    id = number,
    static_ip = string
  }))
}

variable "gateway" {
  type = string
}