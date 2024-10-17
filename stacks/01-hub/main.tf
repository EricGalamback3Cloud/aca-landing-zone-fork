module "hub" {
  source                                     = "./hub"
  workloadName                               = var.workloadName
  environment                                = var.environment
  hubResourceGroupName                       = var.hubResourceGroupName
  location                                   = var.location
  vnetAddressPrefixes                        = var.hubVnetAddressPrefixes
  enableBastion                              = var.enableBastion
  bastionSubnetAddressPrefixes               = var.bastionSubnetAddressPrefixes
  gatewaySubnetAddressPrefix                 = var.gatewaySubnetAddressPrefix
  azureFirewallSubnetAddressPrefix           = var.azureFirewallSubnetAddressPrefix
  azureFirewallSubnetManagementAddressPrefix = var.azureFirewallSubnetManagementAddressPrefix
  infraSubnetAddressPrefix                   = var.infraSubnetAddressPrefix
  tags                                       = var.tags
}