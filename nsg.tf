resource "azurerm_network_security_group" "nsg" {
  name                = "linux-nsg"
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  depends_on = [
    azurerm_network_interface.nic
  ]
  for_each = toset(var.name)
  network_interface_id      = azurerm_network_interface.nic[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = data.azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_rule" "rules" {
  for_each = var.rules
  name                        = lookup(each.value, "name")
  priority                    = lookup(each.value, "priority")
  direction                   = lookup(each.value, "direction")
  access                      = lookup(each.value, "access")
  protocol                    = lookup(each.value, "protocol")
  source_port_range           = lookup(each.value, "source_port_range", null)
  source_port_ranges          = lookup(each.value, "source_port_ranges", null)
  destination_port_range      = lookup(each.value, "destination_port_range", null)
  destination_port_ranges     = lookup(each.value, "destination_port_ranges", null)
  source_address_prefix       = lookup(each.value, "source_address_prefix", null)
  source_address_prefixes     = lookup(each.value, "source_address_prefixes", null)
  destination_address_prefix  = lookup(each.value, "destination_address_prefix", null)
  destination_address_prefixes= lookup(each.value, "destination_address_prefixes", null)
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
