resource "azurerm_key_vault" "this" {
  name                = local.key_vault_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  # Authorization through Azure RBAC, not legacy access policies.
  rbac_authorization_enabled = true

  # Recoverability
  soft_delete_retention_days = 7
  purge_protection_enabled   = true

  # Network: no public endpoint
  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = local.tags
}