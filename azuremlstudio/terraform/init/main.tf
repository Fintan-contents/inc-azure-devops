terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.61.0"
    }
  }
}

provider "azurerm" {
  features {}
}

##### リソースグループ #####
resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-rg"
  location = var.location
}

##### ストレージアカウント #####
resource "azurerm_storage_account" "example" {
  name                     = "${var.prefix}sa"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}

##### key vault #####
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "example" {
  name                = "${var.prefix}-key"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

##### application_insights #####
resource "azurerm_application_insights" "example" {
  name                = "${var.prefix}-apis"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}

resource "azurerm_machine_learning_workspace" "example" {
  name                    = "${var.prefix}-mlws"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  application_insights_id = azurerm_application_insights.example.id
  key_vault_id            = azurerm_key_vault.example.id
  storage_account_id      = azurerm_storage_account.example.id

  identity {
    type = "SystemAssigned"
  }
}
