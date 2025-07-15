# Resource Group & Automation Account
resource_group_name              = "automation"
resource_group_location          = "West Europe"
automation_account_name          = "dev-account"
sku_name                         = "Basic"
tags = {
  environment = "development"
}
public_network_access_enabled    = true
local_authentication_enabled     = true
identity_type                    = "SystemAssigned"
identity_ids                     = []  # Add identity IDs if using UserAssigned or SystemAssigned, UserAssigned
key_vault_key_id                 = null
encryption_user_assigned_identity_id = null

# Runbook
runbook_name                     = "sample-runbook"
runbook_description              = "PowerShell runbook"
runbook_type                     = "PowerShell"
runbook_log_verbose              = true
runbook_log_progress             = true
runbook_file_path                = "scripts/List-AzVMs.ps1"
runbook_parameters               = {}  # Optional: e.g. { "param1" = "value1" }

# Schedule
schedule_name                    = "example-schedule"
schedule_frequency               = "Hour"        # Valid: OneTime, Day, Hour, Minute, Week, Month
schedule_interval                = 1
schedule_timezone                = "UTC"
schedule_start_time              = "2025-07-15T10:00:00Z"
schedule_description             = "Hourly schedule for runbook"

runbooks = [
  {
    name                 = "ListVMs"
    description          = "List all VMs in a resource group"
    runbook_type         = "PowerShell"
    file_path            = "scripts/List-AzVMs.ps1"
    log_verbose          = true
    log_progress         = true
    schedule_name        = "list-vms-daily"
    schedule_frequency   = "Day"
    schedule_interval    = 1
    schedule_timezone    = "UTC"
    schedule_start_time  = "2025-07-16T06:00:00Z"
    schedule_description = "Daily listing of VMs"
    parameters = {
      ResourceGroupName = "my-resource-group"
    }
  }
]