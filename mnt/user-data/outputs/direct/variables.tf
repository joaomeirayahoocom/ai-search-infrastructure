variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-aisearch-poc"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "Storage account name"
  type        = string
  default     = "aisearchdocs001"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "POC"
    Project     = "AI-Search"
    ManagedBy   = "Terraform"
  }
}
