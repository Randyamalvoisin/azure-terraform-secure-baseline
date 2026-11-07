output "resource_group_name" {
  description = "Name of the baseline resource group."
  value       = azurerm_resource_group.this.name
}

output "log_analytics_workspace_name" {
  description = "Name of the central Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.this.name
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the workspace (for use by other modules; not printed in docs)."
  value       = azurerm_log_analytics_workspace.this.id
  sensitive   = true
}

output "storage_account_name" {
  description = "Name of the hardened storage account."
  value       = azurerm_storage_account.this.name
}

output "key_vault_name" {
  description = "Name of the hardened Key Vault."
  value       = azurerm_key_vault.this.name
}

output "workload_subnet_name" {
  description = "Name of the NSG-protected workload subnet."
  value       = azurerm_subnet.workload.name
}