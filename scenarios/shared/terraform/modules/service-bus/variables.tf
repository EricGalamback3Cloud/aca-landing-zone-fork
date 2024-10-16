variable "namespace_name" {
  description = "The name of the Service Bus namespace."
  type        = string
}

variable "topic_name" {
  description = "The name of the Service Bus topic."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the resources will be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be created."
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

variable "tags" {

}

variable "enable_partitioning" {
  description = "Enable partitioning for the topic."
  type        = bool
  default     = false
}
