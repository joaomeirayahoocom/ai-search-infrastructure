# Azure AI Search POC - Complete Infrastructure
# Remote state with Azure Storage backend, CAF-compliant, OIDC authentication

terraform {
  required_version = ">= 1.0"
  
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstateaisearch001"
    container_name       = "tfstate"
    key                  = "ai-search-poc.tfstate"
    use_azuread_auth     = true
  }
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  storage_use_azuread = true
}

# Resource Group
resource "azurerm_resource_group" "ai_search" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Storage Account for PDF documents
resource "azurerm_storage_account" "documents" {
  name                      = var.storage_account_name
  resource_group_name       = azurerm_resource_group.ai_search.name
  location                  = azurerm_resource_group.ai_search.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  shared_access_key_enabled = false

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  tags = var.tags
}

# Blob Container
resource "azurerm_storage_container" "gov_docs" {
  name                  = "government-docs"
  storage_account_id    = azurerm_storage_account.documents.id
  container_access_type = "private"
}

# AI Search Service
resource "azurerm_search_service" "ai_search" {
  name                = var.search_service_name
  resource_group_name = azurerm_resource_group.ai_search.name
  location            = azurerm_resource_group.ai_search.location
  sku                 = var.search_sku
  
  replica_count   = 1
  partition_count = 1
  
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
