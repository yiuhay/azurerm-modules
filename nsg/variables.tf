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

variable "custom_rules" {
  description = "Security rules for the network security group using this format name = [priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix, description]"
  type        = list(any)
  default     = []
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_prefix}-{environment}-RESOURCE_TYPE
  azurerm_rg_name   = "${var.resource_prefix}-${var.env}-rg"
  azurerm_vnet_name = "${var.resource_prefix}-${var.env}-vnet"
  azurerm_snet_name = "${var.resource_prefix}-${var.env}-${var.snet_name}"
  azurerm_nsg_name  = "${var.resource_prefix}-${var.env}-${var.snet_name}-nsg"
}