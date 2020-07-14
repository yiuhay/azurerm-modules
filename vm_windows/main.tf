module "labels" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  
  tags = {
    "environment" = var.env
    "project"     = var.project
    "owner"       = var.owner
  }
}

resource "azurerm_network_interface" "nic_windows" {
  name                = local.azurerm_nic_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  ip_configuration {
    name                          = local.azurerm_nic_ip_config_name
    subnet_id                     = data.azurerm_subnet.snet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vm_private_ip
  }

  tags = module.labels.tags
}

resource "azurerm_virtual_machine" "windows" {
  name                  = local.azurerm_vm_name
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = data.azurerm_resource_group.rg.location
  vm_size               = var.vm_size
  network_interface_ids = azurerm_network_interface.nic_windows.id

  os_profile_windows_config {
    provision_vm_agent = true
    timezone           = "GMT Standard Time"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.os_sku
    version   = "latest"
  }

  storage_os_disk {
    name              = local.azurerm_vm_os_disk_name
    create_option     = "FromImage"
    caching           = "ReadWrite"
    managed_disk_type = "StandardSSD_LRS"
    os_type           = "Windows"
  }

  os_profile {
    computer_name  = local.azurerm_vm_os_profile_computer_name
    admin_username = "adminuser"
    admin_password = data.azurerm_key_vault_secret.winadmin.value
  }

  dynamic "storage_data_disk" {
    for_each = var.additional_data_disk ? ["data"] : []
    content {
      name              = local.azurerm_vm_data_disk_name
      managed_disk_type = var.data_disk_type
      create_option     = "Empty"
      lun               = 0
      disk_size_gb      = var.data_disk_size
      caching           = "ReadWrite"
    }
  }

  tags = module.labels.tags
}
