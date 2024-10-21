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