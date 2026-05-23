variable "proxmox_url" {
  type = string
}

variable "proxmox_node" {
  type = string
}

variable "proxmox_username" {
  type = string
}

variable "proxmox_password" {
  type = string
  sensitive = true
}

variable "ssh_username" {
  type = string
}

variable "ssh_password" {
  type = string
  sensitive = true
}

variable "http_server" {
  type = string
  default = "http"
}