variable "vm_name" {
  type        = string
  description = "Name of the VM"
}

variable "target_node" {
  type        = string
  description = "Proxmox node to deploy VM on"
}

variable "proxmox_vm_id" {
  type        = string
  description = "Template VM ID to clone from"
}

variable "os_type" {
  type        = string
  description = "OS type: windows or linux"
  validation {
    condition     = contains(["windows", "linux"], var.os_type)
    error_message = "OS type must be either 'windows' or 'linux'."
  }
}

variable "vm_cores" {
  type        = number
  description = "Number of CPU cores"
  default     = 2
}

variable "vm_sockets" {
  type        = number
  description = "Number of CPU sockets"
  default     = 1
}

variable "vm_memory" {
  type        = number
  description = "Memory in MB"
  default     = 4096
}

variable "vm_disk_size" {
  type        = number
  description = "Disk size in GB"
  default     = 100
}

variable "ansible_repo" {
  type        = string
  description = "GitHub repository for Ansible automation"
  default     = "tnielsen2/ansible-heezy"
}

variable "ansible_playbooks" {
  type        = string
  description = "Comma-separated list of playbooks to run"
  default     = "baseline"
}

variable "vm_bridge" {
  type        = string
  description = "Proxmox bridge interface"
  default     = "vmbr0"
}

variable "vm_vlan_id" {
  type        = number
  description = "VLAN ID for VM network"
  default     = null
}
