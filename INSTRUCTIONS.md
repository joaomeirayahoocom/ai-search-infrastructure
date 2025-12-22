# Implementation Instructions - Two-Phase Setup

## Overview
Clean separation: Terraform manages resources, PowerShell scripts handle permissions (one-time setup).

---

## Phase 1: Terraform State Storage (Already Done ✅)

You already ran `setup-tfstate.ps1` which created:
- Resource Group: rg-terraform-state
- Storage Account: tfstateaisearch001
- SP permissions on state storage

**Skip this phase - already complete.**

---

## Phase 2: Deploy Application Resources

**Step 1: Update main.tf**
Replace `projects\ai\search\terraform\main.tf` with the new version (role assignments removed)

**Step 2: Commit and Push**
```powershell
cd C:\Users\v-joaomeira\GitHub\Projects\ai-search-poc

git add projects\ai\search\terraform\main.tf
git commit -m "Remove role assignments from Terraform"
git push
```

**Step 3: Deploy**
- GitHub Actions → "Deploy AI Search Infrastructure"
- Select eastus
- Run workflow
- Wait for completion (~2 min)

**Expected:** Resources created but PDF upload will fail (no permissions yet)

---

## Phase 3: Grant Application Permissions (One-Time)

**Step 1: Run setup script**
```powershell
cd C:\Users\v-joaomeira\GitHub\Projects\ai-search-poc
.\setup-app-permissions.ps1
```

**This grants:**
- AI Search → Storage (Reader for indexing)
- Service Principal → Storage (Contributor for uploads)

**Step 2: Re-run Deploy Workflow**
- GitHub Actions → "Deploy AI Search Infrastructure"
- Select eastus
- Run workflow
- This time PDFs will upload successfully ✅

---

## Phase 4: Create AI Search Index (Portal - Last Manual Step)

**In Azure Portal:**
1. Go to aisearch-docs-poc
2. Click "Import data"
3. Data Source: Azure Blob Storage
4. Connection: System-assigned managed identity
5. Container: government-docs
6. Index name: azureblob-index
7. Create indexer
8. Wait 2 min for indexing

**Test search in Search Explorer**

---

## What's Automated vs Manual

**Automated (Terraform + GitHub Actions):**
- ✅ Resource groups
- ✅ Storage accounts
- ✅ Blob containers
- ✅ AI Search service
- ✅ Managed identity
- ✅ PDF uploads

**One-Time Setup (PowerShell):**
- ✅ Terraform state storage
- ✅ Role assignments (run once, work forever)

**Manual (Portal):**
- ❌ Index creation (complex, proven working in Portal)

---

## Files to Download

1. **main.tf** - Updated without role assignments
2. **setup-app-permissions.ps1** - Grants permissions after first deploy

---

## Quick Command Reference

```powershell
# Phase 2: Deploy
git add projects\ai\search\terraform\main.tf
git commit -m "Remove role assignments from Terraform"
git push
# Then run Deploy workflow

# Phase 3: Permissions (after deploy completes)
.\setup-app-permissions.ps1
# Then run Deploy workflow again

# Future deploys: Just run workflow, permissions persist
```

---

**Total Time: 10 minutes**
**Setup Scripts Run: Twice (state + permissions)**
**Result: Fully repeatable infrastructure**
