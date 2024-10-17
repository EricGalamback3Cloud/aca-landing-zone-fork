variable "workloadName" {
  type = string
  validation {
    condition     = length(var.workloadName) >= 2 && length(var.workloadName) <= 10
    error_message = "Name must be greater at least 2 characters and not greater than 10."
  }
}

variable "spokeResourceGroupName" {
  default = ""
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

variable "vmSize" {}

variable "vmAdminUsername" {
  default = "vmadmin"
}

variable "vmAdminPassword" {
  sensitive = true
  default   = null
}

variable "vmLinuxSshAuthorizedKeys" {}

variable "vmLinuxAuthenticationType" {
  type = string
  default = "password"
  validation {
    condition = anytrue([
      var.vmLinuxAuthenticationType == "password",
      var.vmLinuxAuthenticationType == "sshPublicKey"
    ])
    error_message = "Authentication type must be password or sshPublicKey."
  }
}

variable "vmJumpboxOSType" {
  default = "Linux"
  validation {
    condition = anytrue([
      var.vmJumpboxOSType == "Linux",
      var.vmJumpboxOSType == "Windows"
    ])
    error_message = "OS Type must be Linux or Windows."
  }
}

variable "vmSubnetName" {
  default = "snet-jumpbox"
  type    = string
}

variable "spokeVnetAddressPrefixes" {
  default = ""
}

variable "infraSubnetAddressPrefix" {
  default = ""
}

variable "infraSubnetName" {
  default = "snet-infra"
}

variable "privateEndpointsSubnetName" {
  default = "snet-pep"
}

variable "privateEndpointsSubnetAddressPrefix" {
  default = ""
}

variable "vmJumpBoxSubnetAddressPrefix" {}

variable "applicationGatewaySubnetAddressPrefix" {
  default = ""
}

variable "enableTelemetry" {
  type    = bool
  default = true
}