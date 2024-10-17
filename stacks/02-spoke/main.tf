data "terraform_remote_state" "hub" {
  backend = "azurerm"
#   config = {
#     storage_account_name = "your-hub-storage-account"
#     container_name       = "terraform-state"
#     key                  = "hub/tfstate"
#   }
}

output "hub_vnet_id" {
  value = data.terraform_remote_state.hub.outputs.vnet_id
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
  hubVnetId                             = module.hub.hubVnetId
  vmSize                                = var.vmSize
  vmAdminUsername                       = var.vmAdminUsername
  vmAdminPassword                       = var.vmAdminPassword
  vmLinuxSshAuthorizedKeys              = var.vmLinuxSshAuthorizedKeys
  vmLinuxAuthenticationType             = var.vmLinuxAuthenticationType
  vmJumpboxOSType                       = var.vmJumpboxOSType
  jumpboxSubnetAddressPrefix            = var.vmJumpBoxSubnetAddressPrefix
  firewallPrivateIp                     = module.hub.firewallPrivateIp
  tags                                  = var.tags
}