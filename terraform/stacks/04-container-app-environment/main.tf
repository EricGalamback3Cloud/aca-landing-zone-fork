data "terraform_remote_state" "hub" {
  backend = "azurerm"
  config = {
    storage_account_name = var.state_storage_account_name
    container_name       = var.state_container_name
    key                  = var.hub_key
    resource_group_name =  var.state_resource_group_name
  }
}

data "terraform_remote_state" "spoke" {
  backend = "azurerm"
  config = {
    storage_account_name = var.state_storage_account_name
    container_name       = var.state_container_name
    key                  = var.spoke_key
    resource_group_name = var.state_resource_group_name
  }
}

resource "random_string" "random" {
  length  = 5
  special = false
  lower   = true
}

module "naming" {
  source       = "../../shared/modules/naming"
  uniqueId     = random_string.random.result
  environment  = var.environment
  workloadName = var.workloadName
  location     = var.location
}

module "applicationInsights" {
  source            = "../../shared/modules/monitoring/app-insights"
  appInsightsName   = var.appInsightsName
  resourceGroupName = data.terraform_remote_state.spoke.outputs.spokeResourceGroupName
  location          = var.location
  workspaceId       = data.terraform_remote_state.spoke.outputs.logAnalyticsWorkspaceId
  tags              = var.tags
}

module "containerAppsEnvironment" {
  source                  = "../../shared/modules/aca-environment"
  environmentName         = module.naming.resourceNames["containerAppsEnvironment"]
  resourceGroupName       = data.terraform_remote_state.spoke.outputs.spokeResourceGroupName
  location                = var.location
  logAnalyticsWorkspaceId = data.terraform_remote_state.spoke.outputs.logAnalyticsWorkspaceId
  subnetId                = data.terraform_remote_state.spoke.outputs.spokeInfraSubnetId
  workloadProfiles        = var.workloadProfiles
}

module "containerAppsEnvironmentPrivateDnsZone" {
  source            = "../../shared/modules/networking/private-zones"
  resourceGroupName = data.terraform_remote_state.hub.outputs.hubResourceGroupName
  zoneName          = module.containerAppsEnvironment.containerAppsEnvironmentDefaultDomain
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
  records = [
    {
      "name"        = "*"
      "ipv4Address" = [module.containerAppsEnvironment.containerAppsEnvironmentLoadBalancerIP]
    }
  ]
  tags = var.tags
}
