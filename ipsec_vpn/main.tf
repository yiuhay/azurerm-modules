module "labels" {
  source = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  
  tags = {
    "environment" = var.env
    "project"     = var.resource_prefix
    "owner"       = var.owner
  }
}

resource "azurerm_public_ip" "vgw_pip" {
  name                = local.azurerm_vgw_pip
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = module.labels.tags
}

resource "azurerm_virtual_network_gateway" "vgw" {
  name                = local.azurerm_vgw_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  type                = "Vpn"
  vpn_type            = "RouteBased"

  active_active       = false
  enable_bgp          = false
  sku                 = "VpnGw1"

  ip_configuration {
    subnet_id            = data.azurerm_subnet.vgw_snet.id
    public_ip_address_id = azurerm_public_ip.vgw_pip.id
  }

  tags = module.labels.tags
}

resource "azurerm_local_network_gateway" "lgw" {
  name                = local.azurerm_lgw_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  gateway_address     = data.azurerm_key_vault_secret.onprem_public_ip.value
  address_space       = var.onprem_private_ips

  tags = module.labels.tags
}

resource "azurerm_virtual_network_gateway_connection" "cn" {
  name                       = local.azurerm_cn_name
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = data.azurerm_resource_group.rg.location

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vgw.id
  local_network_gateway_id   = azurerm_local_network_gateway.lgw.id

  shared_key                 = data.azurerm_key_vault_secret.vpn_psk.value

  ipsec_policy {
    dh_group         = var.dh_group
    ike_encryption   = var.ike_encryption
    ike_integrity    = var.ike_integrity

    ipsec_encryption = var.ipsec_encryption
    ipsec_integrity  = var.ipsec_integrity
    pfs_group        = var.pfs_group
  }

  tags = module.labels.tags
}