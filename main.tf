resource "azurerm_availability_set" "linux_as" {
  name                        = upper(var.as_name)
  location                    = data.azurerm_resource_group.rg.location
  resource_group_name         = data.azurerm_resource_group.rg.name
  platform_fault_domain_count = 2

  tags = local.tags
}

resource "azurerm_network_interface" "nic" {
  depends_on = [
    azurerm_public_ip.pip
  ]
  for_each = toset(var.name)
  name = lower("${each.key}-nic")
  location = var.location
  resource_group_name = var.rg_name
  enable_accelerated_networking = false
  ip_configuration {
    name = "ipconfig1"
    subnet_id = data.azurerm_subnet.subnet.id
    private_ip_address_version = "IPv4"
    public_ip_address_id = azurerm_public_ip.pip[each.key].id
    primary = true
    private_ip_address_allocation = "Dynamic"
  }
  tags = local.tags
}
resource "azurerm_public_ip" "pip" {
  depends_on = [
    azurerm_availability_set.linux_as
  ]
    for_each = toset(var.name)
  name                = lower("${each.key}-pip")
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Dynamic"

  tags = local.tags
}
resource "azurerm_linux_virtual_machine" "vm_linux" {
  depends_on = [
    azurerm_network_interface.nic
  ]

  for_each = toset(var.name)
  name                            = upper(each.key)
  resource_group_name             = var.rg_name
  location                        = var.location
  size                            = var.size
  admin_username                  = var.admin
  admin_password                  = var.password
  availability_set_id             = azurerm_availability_set.linux_as.id
  disable_password_authentication = false
  network_interface_ids = [
   azurerm_network_interface.nic[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 127
  }

  source_image_reference {
    publisher = lookup(var.os_image, "publisher","canonical")
    offer = lookup(var.os_image,"offer","0001-com-ubuntu-server-focal")
    sku = lookup(var.os_image,"sku","20_04-lts")
    version = lookup(var.os_image,"version","latest")
  }
  tags = local.tags
}
