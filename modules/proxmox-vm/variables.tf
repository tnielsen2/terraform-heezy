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

variable "ansible_playbook" {
  type        = string
  description = "Ansible playbook to run"
  default     = "baseline"
}

variable "ansible_custom_role" {
  type        = string
  description = "Custom Ansible role"
  default     = ""
}
