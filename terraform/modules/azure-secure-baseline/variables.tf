variable "prefix" {
  description = "Short lowercase prefix used in resource names (3-8 letters/digits)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,8}$", var.prefix))
    error_message = "prefix must be 3-8 lowercase letters or digits."
  }
}

variable "environment" {
  description = "Environment name. Drives naming and tags."
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, prod."
  }
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Tags applied to every resource. Must include owner and environment."
  type        = map(string)

  validation {
    condition     = alltrue([for k in ["owner", "environment"] : contains(keys(var.tags), k)])
    error_message = "tags must include at least 'owner' and 'environment'."
  }
}

variable "log_retention_days" {
  description = "Log Analytics retention in days (30 is included at no extra charge)."
  type        = number
  default     = 30
}

variable "log_daily_quota_gb" {
  description = "Daily ingestion cap for Log Analytics. Keeps the lab inside the free allowance."
  type        = number
  default     = 0.1
}

variable "enable_subscription_activity_log" {
  description = "Send the subscription Activity Log to the workspace. Only one environment per subscription should set this to true."
  type        = bool
  default     = true
}

variable "vnet_address_space" {
  description = "Address space for the baseline virtual network."
  type        = string
  default     = "10.10.0.0/16"
}

variable "workload_subnet_prefix" {
  description = "Address prefix for the workload subnet."
  type        = string
  default     = "10.10.1.0/24"
}

variable "budget_amount" {
  description = "Monthly budget for the resource group, in your billing currency."
  type        = number
  default     = 5
}

variable "budget_start_date" {
  description = "Budget start date. Must be the first day of a month, RFC3339 (e.g. 2026-11-01T00:00:00Z)."
  type        = string
}

variable "budget_contact_emails" {
  description = "Email addresses that receive budget alerts."
  type        = list(string)

  validation {
    condition     = length(var.budget_contact_emails) > 0
    error_message = "Provide at least one budget alert email."
  }
}