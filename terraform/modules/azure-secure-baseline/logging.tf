resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${local.name_base}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  daily_quota_gb      = var.log_daily_quota_gb

  # Require Entra ID auth for queries and ingestion (no shared workspace keys).
  local_authentication_enabled = false

  tags = local.tags
}

# Subscription Activity Log -> workspace. Activity Log ingestion is free.
resource "azurerm_monitor_diagnostic_setting" "activity_log" {
  count = var.enable_subscription_activity_log ? 1 : 0

  name                       = "diag-activitylog-to-${azurerm_log_analytics_workspace.this.name}"
  target_resource_id         = data.azurerm_subscription.current.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "Administrative"
  }

  enabled_log {
    category = "Security"
  }

  enabled_log {
    category = "Policy"
  }

  enabled_log {
    category = "Alert"
  }
}

# Key Vault audit events (every secret/key/cert access attempt).
resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  name                       = "diag-${azurerm_key_vault.this.name}"
  target_resource_id         = azurerm_key_vault.this.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "AuditEvent"
  }
}

# Blob service read/write/delete logging.
resource "azurerm_monitor_diagnostic_setting" "storage_blob" {
  name                       = "diag-${azurerm_storage_account.this.name}-blob"
  target_resource_id         = "${azurerm_storage_account.this.id}/blobServices/default"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }
}