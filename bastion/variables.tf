variable "resource_prefix" {
  description = "The prefix used to name all resources"
}

variable "env" {
  description = "e.g. Dev, Production"
}

variable "owner" {
  description = "tagging purposes"
}

variable "target_snet_name" {
  description = "The name of the subnet that the bastion can connect to"
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_prefix}-{environment}-RESOURCE_TYPE
  azurerm_rg_name          = "${var.resource_prefix}-${var.env}-rg"
  azurerm_vnet_name        = "${var.resource_prefix}-${var.env}-vnet"
  azurerm_bastion_name     = "${var.resource_prefix}-${var.env}-bastion"
  azurerm_bastion_pip      = "${local.azurerm_bastion_name}-pip"
  azurerm_bastion_nsg_name = "${var.resource_prefix}-${var.env}-${data.azurerm_subnet.bastion_subnet.name}-nsg"
  azurerm_target_nsg_name  = "${var.resource_prefix}-${var.env}-${var.target_snet_name}-nsg"
}