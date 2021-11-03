terraform {
  required_version = ">= 0.13.0"
}

provider "azurerm" {
  version = "~>2.0"
  features {}
}

provider "random" {
  version = "~> 3.0.0"
}

provider "local" {
  version = "~> 2.0.0"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-${terraform.workspace}"
  location = var.location
}

module "aks" {
  source = "./modules/aks"
  count  = var.k8s_enabled ? 1 : 0

  name                = "${terraform.workspace}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = terraform.workspace
}

module "mysql" {
  source = "./modules/mysql"
  count  = var.db_enabled ? 1 : 0

  name                = "${terraform.workspace}-mysql"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  databases           = var.db_databases
}
