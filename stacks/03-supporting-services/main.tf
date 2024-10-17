data "terraform_remote_state" "hub" {
  backend = "azurerm"
  config = {
    storage_account_name = "erictftesting2"
    container_name       = "tfstate2"
    key                  = "hub/tfstate"
    resource_group_name = "kat"
  }
}

data "terraform_remote_state" "spoke" {
  backend = "azurerm"
  config = {
    storage_account_name = "erictftesting2"
    container_name       = "tfstate2"
    key                  = "spoke/tfstate"
    resource_group_name = "kat"
  }
}

module "supportingServices" {
  source                              = "./modules/03-supporting-services"
  workloadName                        = var.workloadName
  environment                         = var.environment
  location                            = var.location
  spokeResourceGroupName              = data.terraform_remote_state.spoke.outputs.spokeResourceGroupName
  aRecords                            = var.aRecords
  hubResourceGroupName                = data.terraform_remote_state.hub.outputs.hubResourceGroupName
  hubVnetId                           = data.terraform_remote_state.hub.outputs.hubVnetId
  spokeVnetId                         = data.terraform_remote_state.spoke.outputs.spokeVNetId
  spokePrivateEndpointSubnetId        = data.terraform_remote_state.spoke.outputs.spokePrivateEndpointsSubnetId
  containerRegistryPullRoleAssignment = var.containerRegistryPullRoleAssignment
  keyVaultPullRoleAssignment          = var.keyVaultPullRoleAssignment
  clientIP                            = var.clientIP
  logAnalyticsWorkspaceId             = data.terraform_remote_state.spoke.outputs.logAnalyticsWorkspaceId
  supportingResourceGroupName         = var.supportingResourceGroupName

  vnetLinks = [
    {
      "name"                = module.spoke.spokeVNetName
      "vnetId"              = module.spoke.spokeVNetId
      "resourceGroupName"   = module.spoke.spokeResourceGroupName
      "registrationEnabled" = false
    },
    {
      "name"                = module.hub.hubVnetName
      "vnetId"              = module.hub.hubVnetId
      "resourceGroupName"   = module.hub.hubResourceGroupName
      "registrationEnabled" = false
  }]
  tags = var.tags
}