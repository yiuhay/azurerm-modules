output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "snet_id" {
  description = "The ids of subnets created"
  value       = azurerm_subnet.subnet.*.id
}