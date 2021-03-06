module "labels" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  
  tags = {
    "environment" = var.env
    "project"     = var.resource_prefix
    "owner"       = var.owner
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.azurerm_vnet_name
  address_space       = [var.vnet_cidr]
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  tags = module.labels.tags
}

resource "azurerm_subnet" "subnet" {
  count                = length(var.snet_names)
  name                 = var.snet_names[count.index]
  address_prefixes     = [var.snet_prefixes[count.index]]
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}