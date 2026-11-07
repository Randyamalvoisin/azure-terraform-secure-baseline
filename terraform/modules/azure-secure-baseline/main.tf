data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

locals {
  name_base = "${var.prefix}-${var.environment}"

  # Storage and Key Vault names are globally unique, so they get a random suffix.
  storage_account_name = substr("st${var.prefix}${var.environment}${random_string.suffix.result}", 0, 24)
  key_vault_name       = substr("kv-${local.name_base}-${random_string.suffix.result}", 0, 24)

  tags = merge(var.tags, {
    managed_by = "terraform"
    module     = "azure-secure-baseline"
  })
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${local.name_base}-baseline"
  location = var.location
  tags     = local.tags
}