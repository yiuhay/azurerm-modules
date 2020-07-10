data "azurerm_resource_group" "rg" {
  name = local.azurerm_resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = local.azurerm_virtual_network_name
  resource_group_name = data.azurerm_resource_group.rg.name
}