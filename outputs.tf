output "public_ip" {
    value = data.azurerm_public_ip.dynamic_pip[*].ip_address
}