# Setup Terraform State Storage - Run Once
# This creates the infrastructure needed for remote Terraform state

# Variables (already set from OIDC setup)
# $APP_ID
# $SUBSCRIPTION_ID
# $TENANT_ID

Write-Host "Setting up Terraform state storage..." -ForegroundColor Cyan

# Create resource group for Terraform state
Write-Host "`n1. Creating resource group..." -ForegroundColor Yellow
az group create `
  --name rg-terraform-state `
  --location eastus

# Create storage account (CAF-compliant: no shared keys)
Write-Host "`n2. Creating storage account..." -ForegroundColor Yellow
az storage account create `
  --name tfstateaisearch001 `
  --resource-group rg-terraform-state `
  --location eastus `
  --sku Standard_LRS `
  --allow-shared-key-access false

# Create blob container for state files
Write-Host "`n3. Creating blob container..." -ForegroundColor Yellow
az storage container create `
  --name tfstate `
  --account-name tfstateaisearch001 `
  --auth-mode login

# Grant Service Principal access to state storage
Write-Host "`n4. Granting Service Principal permissions..." -ForegroundColor Yellow
az role assignment create `
  --assignee $APP_ID `
  --role "Storage Blob Data Contributor" `
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/rg-terraform-state/providers/Microsoft.Storage/storageAccounts/tfstateaisearch001"

# Verify setup
Write-Host "`n5. Verifying setup..." -ForegroundColor Yellow
az storage account show `
  --name tfstateaisearch001 `
  --resource-group rg-terraform-state `
  --query "{Name:name, AllowSharedKey:allowSharedKeyAccess, Location:location}" `
  --output table

az role assignment list `
  --assignee $APP_ID `
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/rg-terraform-state/providers/Microsoft.Storage/storageAccounts/tfstateaisearch001" `
  --output table

Write-Host "`n✅ Terraform state storage setup complete!" -ForegroundColor Green
Write-Host "`nStorage Account: tfstateaisearch001" -ForegroundColor Cyan
Write-Host "Container: tfstate" -ForegroundColor Cyan
Write-Host "Key: ai-search-poc.tfstate" -ForegroundColor Cyan
