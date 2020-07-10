variable "env" {
  description = "e.g. Dev, Production"
}

variable "location" {
  description = "Location of resources"
}

variable "resource_prefix" {
  description = "The prefix used to name all resources"
}

variable "cidr_vnet" {
  description = "Address space of vnet"
}

variable "owner" {
  description = "tagging purposes"
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_name_prefix}-{environment}-RESOURCE_TYPE
  azurerm_rg_name  = "${var.resource_prefix}-${var.env}-rg"
  azurerm_vnet_name = "${var.resource_prefix}-${var.env}-vnet"
}