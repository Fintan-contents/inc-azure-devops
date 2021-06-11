##### コンテナレジストリの名前 #####
output "azure_container_registry_name" {
  value = "${azurerm_container_registry.example.name}"
}
##### コンテナレジストリのドメイン #####
output "azure_container_registry_domain" {
  value = "${azurerm_container_registry.example.name}.azurecr.io"
}
##### Azure Database for PostgreSQLのサーバー名 #####
output "azure_postgresql_server" {
  value = "${azurerm_postgresql_server.example.name}"
}
##### Azure Cache for Redisのサーバー名 #####
output "azure_redis_cache" {
  value = "${azurerm_redis_cache.example.name}"
}
