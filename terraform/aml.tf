resource "azurerm_application_insights" "example" {
  count = var.existing_workspace_name == "" ? 1 : 0
  name                = "${var.prefix}-insights"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"
}

resource "azurerm_key_vault" "example" {
  count = var.existing_workspace_name == "" ? 1 : 0
  name                     = "${var.prefix}-vault"
  location                 = azurerm_resource_group.main.location
  resource_group_name      = azurerm_resource_group.main.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "premium"
  purge_protection_enabled = true
}

resource "azurerm_storage_account" "example" {
  count = var.existing_workspace_name == "" ? 1 : 0
  name                     = "${var.prefix}storageaml"
  location                 = azurerm_resource_group.main.location
  resource_group_name      = azurerm_resource_group.main.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_machine_learning_workspace" "example" {
  count = var.existing_workspace_name == "" ? 1 : 0
  name                    = "${var.prefix}-workspace"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  application_insights_id = azurerm_application_insights.example.id
  key_vault_id            = azurerm_key_vault.example.id
  storage_account_id      = azurerm_storage_account.example.id

  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_machine_learning_workspace" "example" {
  count = var.existing_workspace_name == "" ? 0 : 1
  name                = var.existing_workspace_name
  resource_group_name = azurerm_resource_group.main.name
}
