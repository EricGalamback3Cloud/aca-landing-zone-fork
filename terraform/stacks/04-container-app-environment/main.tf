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

module "containerAppsEnvironment" {
  source                  = "./modules/container-app-environment"
  workloadName            = var.workloadName
  environment             = var.environment
  location                = var.location
  spokeResourceGroupName  = data.terraform_remote_state.spoke.outputs.spokeResourceGroupName
  hubResourceGroupName    = data.terraform_remote_state.hub.outputs.hubResourceGroupName
  appInsightsName         = var.appInsightsName
  hubVnetId               = data.terraform_remote_state.hub.outputs.hubVnetId
  spokeVnetId             = data.terraform_remote_state.spoke.outputs.spokeVNetId
  spokeInfraSubnetId      = data.terraform_remote_state.spoke.outputs.spokeInfraSubnetId
  logAnalyticsWorkspaceId = data.terraform_remote_state.spoke.outputs.logAnalyticsWorkspaceId
  workloadProfiles        = var.workloadProfiles
  tags                    = var.tags

  vnetLinks = [
    {
      name                = data.terraform_remote_state.spoke.outputs.spokeVNetName
      vnetId              = data.terraform_remote_state.spoke.outputs.spokeVNetId
      resourceGroupName   = data.terraform_remote_state.spoke.outputs.spokeResourceGroupName
      registrationEnabled = false
    },
    {
      name                = data.terraform_remote_state.hub.outputs.hubVnetName
      vnetId              = data.terraform_remote_state.hub.outputs.hubVnetId
      resourceGroupName   = data.terraform_remote_state.hub.outputs.hubResourceGroupName
      registrationEnabled = false
  }]
}
