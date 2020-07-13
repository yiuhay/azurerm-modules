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