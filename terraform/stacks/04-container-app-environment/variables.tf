// ------------------
//    PARAMETERS
// ------------------
variable "workloadName" {
  type = string
  validation {
    condition     = length(var.workloadName) >= 2 && length(var.workloadName) <= 10
    error_message = "Name must be greater at least 2 characters and not greater than 10."
  }
}

variable "environment" {
  type = string
  validation {
    condition     = length(var.environment) <= 8
    error_message = "Environment name can't be greater than 8 characters long."
  }
}

variable "location" {
  type    = string
}

variable "tags" {}

variable "appInsightsName" {
  type = string
  validation {
    condition     = length(var.appInsightsName) >= 4 && length(var.appInsightsName) <= 63
    error_message = "Name must be greater at least 4 characters and not greater than 63."
  }
}

variable "enableTelemetry" {
  type    = bool
  default = true
}

variable "workloadProfiles" {
  description = "Optional, the workload profiles required by the end user. The default is 'Consumption', and is automatically added whether workload profiles are specified or not."
  type = list(object({
    name                  = string
    workload_profile_type = string
    minimum_count         = number
    maximum_count         = number
  }))
  default = []
}

variable "hub_key" {
  default = "hub/tfstate"
}

variable "spoke_key" {
  default = "spoke/tfstate"
}

variable "state_storage_account_name" {}

variable "state_container_name" {}

variable "state_resource_group_name" {}

variable "clientIP" {
  default = ""
}

# Service Bus
variable "namespace_name" {
  description = "The name of the Service Bus namespace."
  type        = string
}

variable "topic_name" {
  description = "The name of the Service Bus topic."
  type        = string
}

variable "sku" {
  description = "The SKU of the Service Bus namespace (Basic, Standard, or Premium)."
  type        = string
  default     = "Standard"
}

variable "enable_partitioning" {
  description = "Enable partitioning for the topic."
  type        = bool
  default     = false
}

variable "create_subscription" {
  description = "Whether to create a subscription for the topic."
  type        = bool
  default     = false
}

variable "subscription_name" {
  description = "The name of the subscription."
  type        = string
  default     = "default-subscription" # This will be ignored if create_subscription is false
}

variable "dapr_pubsub_component_name" {
  description = "The name of the Dapr pubsub component."
  type        = string 
}