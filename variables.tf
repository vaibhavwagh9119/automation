# Resource Group & Automation Account

variable "resource_group_name" {
  description = "The name of the Resource Group"
  type        = string
}

variable "resource_group_location" {
  description = "The Azure region for the Resource Group"
  type        = string
}

variable "automation_account_name" {
  description = "The name of the Automation Account"
  type        = string
}

variable "sku_name" {
  description = "SKU name for the Automation Account (Basic or Free)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the Automation Account"
  type        = map(string)
}

variable "public_network_access_enabled" {
  description = "Enable public network access for the Automation Account"
  type        = bool
}

variable "local_authentication_enabled" {
  description = "Enable local authentication methods (username/password)"
  type        = bool
}

variable "identity_type" {
  description = "Managed Identity type: SystemAssigned, UserAssigned, or both"
  type        = string
}

variable "identity_ids" {
  description = "List of user-assigned identity IDs (used if identity_type includes UserAssigned)"
  type        = list(string)
}

variable "key_vault_key_id" {
  description = "Key Vault key ID used for customer-managed encryption"
  type        = string
  default     = null
}

variable "encryption_user_assigned_identity_id" {
  description = "User-assigned identity ID used to access the encryption key"
  type        = string
  default     = null
}

# Runbook

variable "runbook_name" {
  description = "Name of the PowerShell runbook"
  type        = string
}

variable "runbook_description" {
  description = "Description of the runbook"
  type        = string
}

variable "runbook_type" {
  description = "Type of the runbook (PowerShell, Python2, etc.)"
  type        = string
}

variable "runbook_log_verbose" {
  description = "Enable verbose logging for the runbook"
  type        = bool
}

variable "runbook_log_progress" {
  description = "Enable progress logging for the runbook"
  type        = bool
}

variable "runbook_file_path" {
  description = "Path to the local PowerShell script file for the runbook"
  type        = string
}

variable "runbook_parameters" {
  description = "Parameters to be passed to the runbook at runtime"
  type        = map(string)
}

# Schedule

variable "schedule_name" {
  description = "Name of the automation schedule"
  type        = string
}

variable "schedule_frequency" {
  description = "Frequency for the schedule (OneTime, Day, Hour, Minute, Week, Month)"
  type        = string
}

variable "schedule_interval" {
  description = "Interval for the schedule (e.g., every 1 hour)"
  type        = number
}

variable "schedule_timezone" {
  description = "Timezone for the schedule (e.g., UTC)"
  type        = string
}

variable "schedule_start_time" {
  description = "Start time of the schedule in ISO8601 format (e.g., 2025-07-15T10:00:00Z)"
  type        = string
}

variable "schedule_description" {
  description = "Description of the schedule"
  type        = string
}


variable "runbooks" {
  description = "List of runbooks with individual configuration"
  type = list(object({
    name                 = string
    description          = string
    runbook_type         = string
    file_path            = string
    log_verbose          = bool
    log_progress         = bool
    schedule_name        = string
    schedule_frequency   = string
    schedule_interval    = number
    schedule_timezone    = string
    schedule_start_time  = string
    schedule_description = string
    parameters           = map(string)
  }))
}