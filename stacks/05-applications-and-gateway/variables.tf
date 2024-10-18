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
  appGatewayCertificateKeyName    = var.appGatewayCertificateKeyName
  appGatewayFQDN                  = var.appGatewayFQDN
  appGatewayCertificatePath       = var.appGatewayCertificatePath

# Service Bus
  namespace_name = var.namespace_name
  topic_name = var.topic_name
  location = var.location
  sku = var.sku
  subscription_name = var.subscription_name
  max_delivery_count = var.max_delivery_count
  lock_duration = var.lock_duration
