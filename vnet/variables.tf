variable "resource_prefix" {
  description = "The prefix used to name all resources"
}

variable "vnet_cidr" {
  description = "Address space of vnet"
}

variable "env" {
  description = "e.g. Dev, Production"
}

variable "owner" {
  description = "tagging purposes"
}

variable "snet_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list
  default     = ["10.0.1.0/24"]
}

variable "snet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list
  default     = ["subnet1"]
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_prefix}-{environment}-RESOURCE_TYPE
  azurerm_rg_name  = "${var.resource_prefix}-${var.env}-rg"
  azurerm_vnet_name = "${var.resource_prefix}-${var.env}-vnet"
}