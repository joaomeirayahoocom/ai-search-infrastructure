# Setup Application Permissions - Run AFTER First Deploy
# Grants role assignments that Terraform cannot create

# Variables (already set from OIDC setup)
# $APP_ID
# $SUBSCRIPTION_ID

Write-Host "Setting up application permissions..." -ForegroundColor Cyan

# Get AI Search managed identity principal ID
Write-Host "`n1. Getting AI Search managed identity..." -ForegroundColor Yellow
$SEARCH_PRINCIPAL_ID = (az search service show `
  --name aisearch-docs-poc `
  --resource-group rg-aisearch-poc `
  --query "identity.principalId" -o tsv)

Write-Host "   AI Search Principal ID: $SEARCH_PRINCIPAL_ID" -ForegroundColor Gray

# Grant AI Search → Storage (Reader for indexing)
Write-Host "`n2. Granting AI Search read access to storage..." -ForegroundColor Yellow
az role assignment create `
  --assignee $SEARCH_PRINCIPAL_ID `
  --role "Storage Blob Data Reader" `
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/rg-aisearch-poc/providers/Microsoft.Storage/storageAccounts/aisearchdocs001"

# Grant Service Principal → Storage (Contributor for PDF uploads)
Write-Host "`n3. Granting Service Principal write access to storage..." -ForegroundColor Yellow
az role assignment create `
  --assignee $APP_ID `
  --role "Storage Blob Data Contributor" `
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/rg-aisearch-poc/providers/Microsoft.Storage/storageAccounts/aisearchdocs001"

# Verify permissions
Write-Host "`n4. Verifying permissions..." -ForegroundColor Yellow
Write-Host "   AI Search → Storage:" -ForegroundColor Gray
az role assignment list `
  --assignee $SEARCH_PRINCIPAL_ID `
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/rg-aisearch-poc/providers/Microsoft.Storage/storageAccounts/aisearchdocs001" `
  --output table

Write-Host "`n   Service Principal → Storage:" -ForegroundColor Gray
az role assignment list `
  --assignee $APP_ID `
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/rg-aisearch-poc/providers/Microsoft.Storage/storageAccounts/aisearchdocs001" `
  --output table

Write-Host "`n✅ Application permissions setup complete!" -ForegroundColor Green
Write-Host "`nYou can now:" -ForegroundColor Cyan
Write-Host "  - Upload PDFs via GitHub Actions workflow" -ForegroundColor Cyan
Write-Host "  - Create AI Search index/indexer in Portal" -ForegroundColor Cyan
