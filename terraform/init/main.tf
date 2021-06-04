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
        name = "${var.prefix}-rg"
        location = "${var.location}"
}

##### ストレージアカウント #####
resource "azurerm_storage_account" "example" {
        name = "${var.prefix}"
        resource_group_name = "${azurerm_resource_group.example.name}"
        location = "${azurerm_resource_group.example.location}"
        account_tier = "Standard"
        account_replication_type = "LRS"

        tags = {
              environment = "staging"
        }
}

##### ストレージコンテナ #####
resource "azurerm_storage_container" "example-chat" {
        name = "example-chat"
        storage_account_name = "${azurerm_storage_account.example.name}"
        container_access_type = "private"
}

##### コンテナレジストリ #####
resource "azurerm_container_registry" "example" {
        name = "${var.prefix}"
        resource_group_name = "${azurerm_resource_group.example.name}"
        location = "${azurerm_resource_group.example.location}"
        sku = "Basic"
        admin_enabled = true
}

##### Azure Database for PostgreSQL #####
resource "azurerm_postgresql_server" "example" {
        name = "${var.prefix}"
        location = "${azurerm_resource_group.example.location}"
        resource_group_name = "${azurerm_resource_group.example.name}"

        sku_name = "B_Gen5_1"

        storage_mb = 5120
        backup_retention_days = 7
        geo_redundant_backup_enabled = false
        auto_grow_enabled = true

        administrator_login = "${var.dbadmin}"
        administrator_login_password = "${var.dbpassword}"
        version = "11"
        ssl_enforcement_enabled = true
}

resource "azurerm_postgresql_firewall_rule" "example" {
       name = "appservice"
       resource_group_name = "${azurerm_resource_group.example.name}"
       server_name = "${azurerm_postgresql_server.example.name}"
       start_ip_address = "0.0.0.0"
       end_ip_address = "0.0.0.0"
}

##### Azure Cache for Redis #####
resource "azurerm_redis_cache" "example" {
       name = "${var.prefix}"
       location = "${azurerm_resource_group.example.location}"
       resource_group_name = "${azurerm_resource_group.example.name}"
       capacity = 0
       family = "C"
       sku_name = "Basic"
       enable_non_ssl_port = false
       minimum_tls_version = "1.2"
       public_network_access_enabled = true

       redis_configuration {
       }
}
