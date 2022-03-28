terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.98.0"
    }
  }
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

module "netspoke" {
  source  = "app.terraform.io/rpecor/netspoke/azurerm"
  version = "0.0.4"

  resource_group_name = "${local.naming}-spoke_vnet-rg"
  location = var.location
  nsg_name = var.nsg_name
  team_name = var.projectName
  v_cidr   = var.cidr_range
  v_name   = "${local.naming}-spoke_vnet"

  tags = local.tags
}