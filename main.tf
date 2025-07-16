provider "azurerm" {
  features {}
  subscription_id = "50a1390f-363e-4a28-aa4f-941af322a11c"
}
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_automation_account" "auto-account" {
  name                                  = var.automation_account_name
  location                              = azurerm_resource_group.rg.location
  resource_group_name                   = azurerm_resource_group.rg.name
  sku_name                              = var.sku_name
  tags                                  = var.tags
  public_network_access_enabled         = var.public_network_access_enabled
  local_authentication_enabled          = var.local_authentication_enabled

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  # encryption {
  #   key_vault_key_id              = var.key_vault_key_id
  #   user_assigned_identity_id     = var.encryption_user_assigned_identity_id
  # }
 }

resource "azurerm_automation_runbook" "runbook" {
  for_each                = { for rb in var.runbooks : rb.name => rb }
  name                    = each.value.name
  location                = azurerm_automation_account.auto-account.location
  resource_group_name     = azurerm_resource_group.rg.name
  automation_account_name = azurerm_automation_account.auto-account.name
  log_verbose             = each.value.log_verbose
  log_progress            = each.value.log_progress
  description             = each.value.description
  runbook_type            = each.value.runbook_type
  content                 = file(each.value.file_path)

  publish_content_link {
    uri = "https://github.com/kdev/automation/blob/main/scripts/List-AzVMs.ps1"
    }
}
resource "azurerm_automation_schedule" "schedule" {
  for_each                = { for rb in var.runbooks : rb.name => rb }
  name                    = each.value.schedule_name
  resource_group_name     = azurerm_resource_group.rg.name
  automation_account_name = azurerm_automation_account.auto-account.name
  frequency               = each.value.schedule_frequency
  interval                = each.value.schedule_interval
  timezone                = each.value.schedule_timezone
  start_time              = each.value.schedule_start_time
  description             = each.value.schedule_description
}
resource "azurerm_automation_job_schedule" "job-schedule" {
  for_each                = { for rb in var.runbooks : rb.name => rb }
  resource_group_name     = azurerm_resource_group.rg.name
  automation_account_name = azurerm_automation_account.auto-account.name
  schedule_name           = azurerm_automation_schedule.schedule[each.key].name
  runbook_name            = azurerm_automation_runbook.runbook[each.key].name
  parameters              = each.value.parameters
}