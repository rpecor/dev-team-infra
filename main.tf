terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.98.0"
    }
  }

  # Setting remote backend to TFC
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "rpecor"

  # prefixed workspaces to support multiple environments in the future
    workspaces {
      prefix = "dev-team-infra-"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  naming = "${var.projectName}-${var.env}"
  tags = {
    project     = var.projectName
    region      = var.location
    environment = var.env
  }
}

resource "azurerm_resource_group" "dev-rg" {
  name     = "${local.naming}-rg"
  location = var.location

  tags = local.tags
}

# Using the remote module in the private registry for my organization in 'source'
module "netspoke" {
  source  = "app.terraform.io/rpecor/netspoke/azurerm"

  # Versioned via Git tags. When tag is pushed, module is versioned. 
  version = "0.0.10"

  resource_group_name = "${local.naming}-spoke_vnet-rg"
  location = var.location
  nsg_name = var.nsg_name
  team_name = var.projectName
  v_cidr   = var.cidr_range
  v_name   = "${local.naming}-spoke_vnet"
  dns_servers = var.dns_servers
  subnets = var.subnets

  tags = local.tags
}

# Create the NIC on the Subnet created via the Network Teams Module. 
resource "azurerm_network_interface" "dev-nic" {
  name                = "${local.naming}-dev-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.netspoke.subnet_id[0]
    private_ip_address_allocation = "Dynamic"
  }
}

# Creating a simple linux VM
resource "azurerm_linux_virtual_machine" "dev-vm" {
  name                = "${local.naming}-dev-vm"
  resource_group_name = azurerm_resource_group.dev-rg.name
  location            = var.location
  size                = "Standard_B1ls"
  admin_username      = "rp-admin"
  admin_password      = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.dev-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}