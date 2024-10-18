# Common
variable "tags" {}
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

# hello-world
variable "workloadProfileName" {
  type    = string
}

variable "helloWorldContainerAppName" {
  type    = string
  default = "ca-simple-hello"
  validation {
    condition     = length(var.helloWorldContainerAppName) >= 2 && length(var.helloWorldContainerAppName) <= 32
    error_message = "Name must be greater at least 2 characters and not greater than 32."
  }
}

# Application Gateway
variable "appGatewayCertificateKeyName" {}
variable "appGatewayFQDN" {}
variable "appGatewayCertificatePath" {
  default = "configuration/acahello.demoapp.com.pfx"
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

variable "max_delivery_count" {
  description = "The maximum number of delivery attempts before the message is dead-lettered."
  type        = number
  default     = 10
}

variable "lock_duration" {
  description = "The duration for which the message is locked."
  type        = string
  default     = "PT1M"
}

variable "hub_key" {
  default = "hub/tfstate"
}

variable "spoke_key" {
  default = "spoke/tfstate"
}

variable "container_app_env_key" {
  default = "containerappenv/tfstate"
}

variable "supporting_services_key" {
  default = "supportingservices/tfstate"
}

variable "state_storage_account_name" {}

variable "state_container_name" {}

variable "state_resource_group_name" {}

variable "clientIP" {
  default = ""
}