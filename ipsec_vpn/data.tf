data "azurerm_resource_group" "rg" {
  name = local.azurerm_rg_name
}

data "azurerm_virtual_network" "vnet" {
  name                = local.azurerm_vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "vgw_snet" {
  name                 = "GatewaySubnet"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

data "azurerm_key_vault_secret" "onprem_public_ip" {
  name         = var.onprem_public_ip
  key_vault_id = local.azurerm_subscription_secret_id
  provider     = azurerm.keyvaultProvider
}

data "azurerm_key_vault_secret" "vpn_psk" {
  name         = var.vpn_psk
  key_vault_id = local.azurerm_subscription_secret_id
  provider     = azurerm.keyvaultProvider
}