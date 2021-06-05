output "azure_container_registry_name" {
  value = "${azurerm_container_registry.example.name}"
}

output "azure_container_registry_domain" {
  value = "${azurerm_container_registry.example.name}.azurecr.io"
}

output "azure_postgresql_server" {
  value = "${azurerm_postgresql_server.example.name}"
}

output "azure_redis_cache" {
  value = "${azurerm_redis_cache.example.name}"
}
