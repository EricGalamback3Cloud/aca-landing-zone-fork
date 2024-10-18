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
  source                              = "./modules/supporting-services"
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
      "name"                = data.terraform_remote_state.spoke.outputs.spokeVNetName
      "vnetId"              = data.terraform_remote_state.spoke.outputs.spokeVNetId
      "resourceGroupName"   = data.terraform_remote_state.spoke.outputs.spokeResourceGroupName
      "registrationEnabled" = false
    },
    {
      "name"                = data.terraform_remote_state.hub.outputs.hubVnetName
      "vnetId"              = data.terraform_remote_state.hub.outputs.hubVnetId
      "resourceGroupName"   = data.terraform_remote_state.hub.outputs.hubResourceGroupName
      "registrationEnabled" = false
  }]
  tags = var.tags
}