module "labels" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  
  tags = {
    "environment" = var.env
    "project"     = var.resource_prefix
    "owner"       = var.owner
  }
}

resource "azurerm_public_ip" "bastion_pip" {
  name                = local.azurerm_bastion_pip
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = module.labels.tags
}

resource "azurerm_bastion_host" "bastion" {
  name                 = local.azurerm_bastion_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  ip_configuration {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.bastion_snet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }

  tags = module.labels.tags
}

# Bastion NSG
resource "azurerm_network_security_group" "bastion_nsg" {
  name                = local.azurerm_bastion_nsg_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  tags = module.labels.tags
}

resource "azurerm_network_security_rule" "ingress_bastion_any" {
  name                        = "InboundFromAny"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
}

resource "azurerm_network_security_rule" "ingress_bastion_gm" {
  name                        = "InboundFromGM"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["443",
                                 "4443",
                                ]
  source_address_prefix       = "GatewayManager"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
}

resource "azurerm_network_security_rule" "egress_bastion_azure" {
  name                        = "OutboundHTTPStoAzureCloud"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "AzureCloud"
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
}

resource "azurerm_network_security_rule" "egress_bastion_rdp" {
  name                        = "OutboundToVNET_RDP"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
}

resource "azurerm_network_security_rule" "egress_bastion_ssh" {
  name                        = "OutboundToVNET_SSH"
  priority                    = 120
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.bastion_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "snet_assoc" {
  subnet_id                 = data.azurerm_subnet.bastion_snet.id
  network_security_group_id = azurerm_network_security_group.bastion_nsg.id

  depends_on = [azurerm_bastion_host.bastion, azurerm_network_security_group.bastion_nsg]
}

# target nsg
resource "azurerm_network_security_rule" "target_ingress_ssh" {
  name                        = "InboundFromSSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = data.azurerm_subnet.bastion_snet.address_prefixes
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = local.azurerm_network_security_group.target_nsg
}

resource "azurerm_network_security_rule" "target_ingress_rdp" {
  name                        = "InboundFromRDP"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefixes     = data.azurerm_subnet.bastion_snet.address_prefixes
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.rg.name
  network_security_group_name = local.azurerm_network_security_group.target_nsg
}