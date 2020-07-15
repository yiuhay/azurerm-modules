variable "resource_prefix" {
  description = "The prefix used to name all resources"
}

variable "env" {
  description = "e.g. Dev, Production"
}

variable "owner" {
  description = "tagging purposes"
}

variable "onprem_public_ip" {
  description = "Public IP for on premise"
}

variable "vpn_psk" {
  description = "PSK set for IPsec VPN"
}


variable "onprem_private_ips" {
  description = "A list of address ranges the on premise target will expose"
  type        = list
  default     = []
}

variable "dh_group" {
  description = "Phase 1"
  type        = string 
}

variable "ike_encryption" {
  description = "Phase 1"
  type        = string 
}

variable "ike_integrity" {
  description = "Phase 1"
  type        = string    
}

variable "ipsec_encryption" {
  description = "Phase 2"
  type        = string 
}

variable "ipsec_integrity" {
  description = "Phase 2"
  type        = string 
}

variable "pfs_group" {
  description = "Phase 2"
  type        = string    
}

locals {
  # Define resource names based on the following convention:
  # {azurerm_resource_prefix}-{environment}-RESOURCE_TYPE
  azurerm_rg_name   = "${var.resource_prefix}-${var.env}-rg"
  azurerm_vnet_name = "${var.resource_prefix}-${var.env}-vnet"
  azurerm_vgw_name  = "${var.resource_prefix}-${var.env}-vgw"
  azurerm_vgw_pip   = "${local.azurerm_vgw_name}-pip"
  azurerm_lgw_name  = "${var.resource_prefix}-${var.env}-lgw"
  azurerm_cn_name   = "${local.azurerm_lgw_name}-to-${local.azurerm_vgw_name}-cn"
}