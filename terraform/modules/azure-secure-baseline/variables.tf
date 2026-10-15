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