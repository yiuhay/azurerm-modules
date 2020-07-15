variable "resource_prefix" {
  description = "The prefix used to name all resources"
}

variable "env" {
  description = "e.g. Dev, Production"
}

variable "owner" {
  description = "tagging purposes"
}

variable "subscription_secret_id" {
  description = "Subscription ID where Key Vault is"
}

variable "snet_name" {
  description = "The name of the snet"
}

variable "vm_name" {
  description = "The name of the virtual machine"
}

variable "vm_private_ip" {
  description = "The static private IP address to assign to the VM"
}

variable "vm_size" {
  description = "The size of the virtual machine"
}

variable "os_sku" {
  description = "Image SKU name e.g. 2019-Datacenter"
}

variable "additional_data_disk" {
  description = "Specify if an additional Data Disks should be created for each VM"
  default = false
}

variable "data_disk_type" {
  description = "Standard_LRS, StandardSSD_LRS, Premium_LRS or UltraSSD_LRS"
  type        = string
}

variable "data_disk_size" {
  description = "size in GB"
  type = string
}

variable "win_admin_password" {
  description = "Key Vault Secret Name"
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_prefix}-{environment}-RESOURCE_TYPE
  azurerm_rg_name            = "${var.resource_prefix}-${var.env}-rg"
  azurerm_rg_secret_name     = "${var.resource_prefix}-${var.env}-secret-rg"
  azurerm_kv_name            = "${var.resource_prefix}-${var.env}-kv"
  azurerm_vnet_name          = "${var.resource_prefix}-${var.env}-vnet"
  azurerm_snet_name          = "${var.resource_prefix}-${var.env}-${var.snet_name}"
  azurerm_nic_name           = "${var.resource_prefix}-${var.env}-${var.vm_name}-nic"
  azurerm_nic_ip_config_name = "${var.resource_prefix}-${var.env}-${var.vm_name}-nic-ip-config"
  azurerm_vm_name            = "${var.resource_prefix}-${var.env}-${var.vm_name}-vm"
  azurerm_vm_os_disk_name    = "${var.resource_prefix}-${var.env}-${var.vm_name}-os"
  azurerm_vm_computer_name   = "digi-az-${var.vm_name}"
  azurerm_vm_data_disk_name  = "${var.resource_prefix}-${var.env}-${var.vm_name}-data"
}