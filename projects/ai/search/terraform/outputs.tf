output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.ai_search.name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.documents.name
}

output "container_name" {
  description = "Name of the blob container"
  value       = azurerm_storage_container.gov_docs.name
}

output "search_service_name" {
  description = "Name of the AI Search service"
  value       = azurerm_search_service.ai_search.name
}

output "search_service_endpoint" {
  description = "Endpoint URL for AI Search service"
  value       = "https://${azurerm_search_service.ai_search.name}.search.windows.net"
}
