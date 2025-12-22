output "resource_group_name" {
  value = azurerm_resource_group.ai_search.name
}

output "storage_account_name" {
  value = azurerm_storage_account.documents.name
}

output "container_name" {
  value = azurerm_storage_container.gov_docs.name
}

output "search_service_name" {
  value = azurerm_search_service.ai_search.name
}

output "search_service_endpoint" {
  value = "https://${azurerm_search_service.ai_search.name}.search.windows.net"
}
