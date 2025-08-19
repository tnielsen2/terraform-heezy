variable "project_name" {
  type        = string
  description = "Heezy Proxmox VM Provisioning"
  default     = "terraform-proxmox"
}

variable "region" {
  type        = string
  description = "Default AWS Region"
  default     = "us-east-2"
}

variable "ansible_repo" {
  type        = string
  description = "GitHub repository for Ansible automation"
  default     = "your-org/ansible-automation"
}

variable "ansible_playbook" {
  type        = string
  description = "Default Ansible playbook to run"
  default     = "vm-bootstrap"
}

variable "ansible_linux_role" {
  type        = string
  description = "Specific role for Linux VM (e.g., minecraft-server)"
  default     = ""
}

variable "ansible_windows_role" {
  type        = string
  description = "Specific role for Windows VM (e.g., game-server)"
  default     = ""
}
