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


data "terraform_remote_state" "supporting_services" {
  backend = "azurerm"
  config = {
    storage_account_name = var.state_storage_account_name
    container_name       = var.state_container_name
    key                  = var.supporting_services_key
    resource_group_name = var.state_resource_group_name
  }
}

data "terraform_remote_state" "container_app_env" {
  backend = "azurerm"
  config = {
    storage_account_name = var.state_storage_account_name
    container_name       = var.state_container_name
    key                  = var.container_app_env_key
    resource_group_name = var.state_resource_group_name
  }
}

module "helloWorldApp" {
  source                                  = "./modules/hello-world"
  deployApp                               = true
  resourceGroupName                       = data.terraform_remote_state.spoke.outputs.spokeResourceGroupName
  helloWorldContainerAppName              = var.helloWorldContainerAppName
  containerAppsEnvironmentId              = data.terraform_remote_state.container_app_env.outputs.containerAppsEnvironmentId
  containerRegistryUserAssignedIdentityId = data.terraform_remote_state.supporting_services.outputs.containerRegistryUserAssignedIdentityId
  workloadProfileName                     = "Consumption"
  tags                                    = var.tags
}

# If you would like to deploy an Application Gateway and have provided your IP address for KeyVault access, leave this module uncommented
module "applicationGateway" {
  source                          = "./modules/application-gateway"
  workloadName                    = var.workloadName
  environment                     = var.environment
  location                        = var.location
  resourceGroupName               = data.terraform_remote_state.spoke.outputs.spokeResourceGroupName
  keyVaultName                    = data.terraform_remote_state.supporting_services.outputs.keyVaultName
  appGatewayCertificateKeyName    = var.appGatewayCertificateKeyName
  appGatewayFQDN                  = var.appGatewayFQDN
  appGatewayPrimaryBackendEndFQDN = module.helloWorldApp.helloWorldAppFQDN
  appGatewaySubnetId              = data.terraform_remote_state.spoke.outputs.spokeApplicationGatewaySubnetId
  appGatewayLogAnalyticsId        = data.terraform_remote_state.spoke.outputs.logAnalyticsWorkspaceId
  appGatewayCertificatePath       = var.appGatewayCertificatePath
  logAnalyticsWorkspaceId         = data.terraform_remote_state.spoke.outputs.logAnalyticsWorkspaceId
  tags                            = var.tags
}

module "serviceBus" {
  source = "./modules/service-bus"
  namespace_name = var.namespace_name
  topic_name = var.topic_name
  resourceGroupName = data.terraform_remote_state.spoke.outputs.spokeResourceGroupName
  location = var.location
  sku = var.sku
  enable_partitioning = true
  create_subscription = true
  subscription_name = var.subscription_name
  max_delivery_count = var.max_delivery_count
  lock_duration = var.lock_duration
  tags = var.tags
}