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
  default = "northeurope"
}

variable "hubResourceGroupName" {
  default = ""
}

variable "tags" {}

variable "hubVnetAddressPrefixes" {}

variable "enableBastion" {
  default = true
  type    = bool
}

variable "bastionSubnetAddressPrefixes" {}

variable "applicationGatewaySubnetAddressPrefix" {
  default = ""
}

variable "azureFirewallSubnetName" {
  default = "AzureFirewallSubnet"
  type    = string
}

variable "azureFirewallSubnetManagementAddressPrefix" {}

variable "azureFirewallSubnetAddressPrefix" {}

variable "gatewaySubnetAddressPrefix" {}

variable "infraSubnetAddressPrefix" {
  default = ""
}

variable "enableTelemetry" {
  type    = bool
  default = true
}