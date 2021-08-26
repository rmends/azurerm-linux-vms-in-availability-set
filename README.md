# azurerm-linux-vms-in-availability-set
Terraform module to create a cluster of Linux VMs into a Availability Set on Azure


# Build and Test

Example of how to build a code using this module.

```
terraform {
  required_providers {
    azurerm   = {
      source  = "hashicorp/azurerm"
      version = ">=2.60.0"
    }
  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "cluster_linux" {
  name     = "cluster_linux"
  location = var.location
}

module "vnet_linux" {
  source = "./module/vnet"

  vnet_name      = "linux_vnet1"
  address_space  = "192.168.0.0/16"
  subnet_name    = "linux_subnet1"
  address_prefix = "192.168.1.0/24"
  resource_group = "${azurerm_resource_group.cluster_linux.name}"
  region         = "East US"

  depends_on     = [
    azurerm_resource_group.cluster_linux
  ]
}

module "cluster" {
    depends_on = [
      module.vnet_linux
    ]
    source = "git::https://github.com/rmends/azurerm-linux-vms-in-availability-set"

    name            = ["srvlnxubt001", "srvlnxubt002", "srvlnxubt003"]
    as_name         = "linux-set"
    rg_name         = "${azurerm_resource_group.cluster_linux.name}"
    location        = "${azurerm_resource_group.cluster_linux.location}"
    password        = var.password
    vnet_name       = "${module.vnet_linux.vnet_name}"
    subnet_name     = "${module.vnet_linux.subnet_name}"

    rules = {
        rule1 = {
            name                        = "Allow_IN_SSH_CONNECTION"
            priority                    = 120
            direction                   = "Inbound"
            access                      = "Allow"
            protocol                    = "Tcp"
            source_port_range           = "*"
            destination_port_range      = "22"
            source_address_prefix       = "*"
            destination_address_prefix  = "*"
            }
        rule2 = {
            name                        = "Allow_IN_DOCKER"
            priority                    = 130
            direction                   = "Inbound"
            access                      = "Allow"
            protocol                    = "Tcp"
            source_port_range           = "*"
            destination_port_ranges     = ["8000", "8080", "8081", "8082", "8083", "8084", "8085"]
            source_address_prefix       = "*"
            destination_address_prefix  = "*"
            }
        }
}

```
