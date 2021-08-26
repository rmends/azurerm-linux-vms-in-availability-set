data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

data "azurerm_resource_group" "rg" {
  name                 = var.rg_name
}

data "azurerm_public_ip" "dynamic_pip" {
  for_each = toset(var.name)
  name                = azurerm_public_ip.pip[each.key].name
  resource_group_name = var.rg_name
}