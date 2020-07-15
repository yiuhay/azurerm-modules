data "azurerm_resource_group" "rg" {
  name = local.azurerm_rg_name
}

data "azurerm_virtual_network" "vnet" {
  name                = local.azurerm_vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "snet" {
  name                 = local.azurerm_snet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

data "azurerm_key_vault_secret" "winadmin" {
  name         = var.win_admin_password
  key_vault_id = "/subscriptions/${var.subscription_secret_id}/resourceGroups/${local.azurerm_rg_secret_name}/providers/Microsoft.KeyVault/vaults/${local.azurerm_kv_name}"
  provider     = azurerm.keyvaultProvider
}