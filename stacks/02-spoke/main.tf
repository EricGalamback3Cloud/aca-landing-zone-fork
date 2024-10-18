data "terraform_remote_state" "hub" {
  backend = "azurerm"
  config = {
    storage_account_name = "erictftesting2"
    container_name       = "tfstate2"
    key                  = "hub/tfstate"
    resource_group_name = "kat"
  }
}

module "spoke" {
  source                                = "./modules/spoke"
  workloadName                          = var.workloadName
  environment                           = var.environment
  spokeResourceGroupName                = var.spokeResourceGroupName
  location                              = var.location
  vnetAddressPrefixes                   = var.spokeVnetAddressPrefixes
  infraSubnetAddressPrefix              = var.infraSubnetAddressPrefix
  infraSubnetName                       = var.infraSubnetName
  privateEndpointsSubnetAddressPrefix   = var.privateEndpointsSubnetAddressPrefix
  applicationGatewaySubnetAddressPrefix = var.applicationGatewaySubnetAddressPrefix
  hubVnetId                             = data.terraform_remote_state.hub.outputs.hubVnetId
  vmSize                                = var.vmSize
  vmAdminUsername                       = var.vmAdminUsername
  vmAdminPassword                       = var.vmAdminPassword
  vmLinuxSshAuthorizedKeys              = var.vmLinuxSshAuthorizedKeys
  vmLinuxAuthenticationType             = var.vmLinuxAuthenticationType
  vmJumpboxOSType                       = var.vmJumpboxOSType
  jumpboxSubnetAddressPrefix            = var.vmJumpBoxSubnetAddressPrefix
  firewallPrivateIp                     = data.terraform_remote_state.hub.outputs.firewallPrivateIp
  tags                                  = var.tags
}