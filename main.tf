provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_automation_account" "example" {
  name                                  = var.automation_account_name
  location                              = azurerm_resource_group.example.location
  resource_group_name                   = azurerm_resource_group.example.name
  sku_name                              = var.sku_name
  tags                                  = var.tags
  public_network_access_enabled         = var.public_network_access_enabled
  local_authentication_enabled          = var.local_authentication_enabled

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  encryption {
    key_vault_key_id              = var.key_vault_key_id
    user_assigned_identity_id     = var.encryption_user_assigned_identity_id
  }
}

resource "azurerm_automation_runbook" "example" {
  name                    = var.runbook_name
  location                = azurerm_automation_account.example.location
  resource_group_name     = azurerm_resource_group.example.name
  automation_account_name = azurerm_automation_account.example.name
  log_verbose             = var.runbook_log_verbose
  log_progress            = var.runbook_log_progress
  description             = var.runbook_description
  runbook_type            = var.runbook_type
  content                 = file(var.runbook_file_path)
  publish_content_link {
    uri = null  # content is provided via `content`
  }
}

resource "azurerm_automation_schedule" "example" {
  name                    = var.schedule_name
  resource_group_name     = azurerm_resource_group.example.name
  automation_account_name = azurerm_automation_account.example.name
  frequency               = var.schedule_frequency
  interval                = var.schedule_interval
  timezone                = var.schedule_timezone
  start_time              = var.schedule_start_time
  description             = var.schedule_description
}

resource "azurerm_automation_job_schedule" "example" {
  resource_group_name     = azurerm_resource_group.example.name
  automation_account_name = azurerm_automation_account.example.name
  schedule_name           = azurerm_automation_schedule.example.name
  runbook_name            = azurerm_automation_runbook.example.name
  parameters              = var.runbook_parameters
}
