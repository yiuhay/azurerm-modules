variable "resource_prefix" {
  description = "The prefix used to name all resources"
}

variable "env" {
  description = "e.g. Dev, Production"
}

variable "owner" {
  description = "tagging purposes"
}

variable "snet_name" {
  description = "The name of the snet"
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_prefix}-{environment}-RESOURCE_TYPE
  azurerm_rg_name   = "${var.resource_prefix}-${var.env}-rg"
  azurerm_vnet_name = "${var.resource_prefix}-${var.env}-vnet"
  azurerm_snet_name = "${var.resource_prefix}-${var.env}-${var.snet_name}-snet"
  azurerm_nsg_name  = "${var.resource_prefix}-${var.env}-${var.snet_name}-nsg"
}