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
  source       = "../../shared/terraform/modules/naming"
  uniqueId     = random_string.random.result
  environment  = var.environment
  workloadName = var.workloadName
  location     = var.location
}

module "containerRegistry" {
  source                                    = "../../shared/terraform/modules/acr"
  acrName                                   = module.naming.resourceNames["containerRegistry"]
  spokeResourceGroupName                    = data.terraform_remote_state.spoke.outputs.spokeResourceGroupName
  hubResourceGroupName                      = data.terraform_remote_state.hub.outputs.hubResourceGroupName
  location                                  = var.location
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
  aRecords                                  = var.aRecords
  subnetId                                  = data.terraform_remote_state.spoke.outputs.spokePrivateEndpointsSubnetId
  containerRegistryUserAssignedIdentityName = module.naming.resourceNames["containerRegistryUserAssignedIdentity"]
  containerRegistryPullRoleAssignment       = var.containerRegistryPullRoleAssignment
  containerRegistryPep                      = module.naming.resourceNames["containerRegistryPep"]
  tags                                      = var.tags
}


module "keyVault" {
  source                           = "../../shared/terraform/modules/keyvault"
  spokeResourceGroupName           = data.terraform_remote_state.spoke.outputs.spokeResourceGroupName
  hubResourceGroupName             = data.terraform_remote_state.hub.outputs.hubResourceGroupName
  keyVaultName                     = module.naming.resourceNames["keyVault"]
  location                         = var.location
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
  aRecords                         = var.aRecords
  subnetId                         = data.terraform_remote_state.spoke.outputs.spokePrivateEndpointsSubnetId
  keyVaultUserAssignedIdentityName = module.naming.resourceNames["keyVaultUserAssignedIdentity"]
  keyVaultPullRoleAssignment       = var.keyVaultPullRoleAssignment
  keyVaultPep                      = module.naming.resourceNames["keyVaultPep"]
  clientIP                         = var.clientIP
  tags                             = var.tags
}

module "diagnostics" {
  source                  = "../../shared/terraform/modules/diagnostics"
  logAnalyticsWorkspaceId = data.terraform_remote_state.spoke.outputs.logAnalyticsWorkspaceId
  resources = [
    {
      type = "keyvault"
      id   = module.keyVault.keyVaultId
    },
    {
      type = "acr"
      id   = module.containerRegistry.acrId
    }
  ]
}