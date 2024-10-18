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

module "helloWorldApp" {
  source                                  = "./modules/hello-world"
  deployApp                               = true
  resourceGroupName                       = module.spoke.spokeResourceGroupName
  helloWorldContainerAppName              = var.helloWorldContainerAppName
  containerAppsEnvironmentId              = module.containerAppsEnvironment.containerAppsEnvironmentId
  containerRegistryUserAssignedIdentityId = module.supportingServices.containerRegistryUserAssignedIdentityId
  workloadProfileName                     = "Consumption"
  tags                                    = var.tags
}

# If you would like to deploy an Application Gateway and have provided your IP address for KeyVault access, leave this module uncommented
module "applicationGateway" {
  source                          = "./modules/application-gateway"
  workloadName                    = var.workloadName
  environment                     = var.environment
  location                        = var.location
  resourceGroupName               = module.spoke.spokeResourceGroupName
  keyVaultName                    = module.supportingServices.keyVaultName
  appGatewayCertificateKeyName    = var.appGatewayCertificateKeyName
  appGatewayFQDN                  = var.appGatewayFQDN
  appGatewayPrimaryBackendEndFQDN = module.helloWorldApp.helloWorldAppFQDN
  appGatewaySubnetId              = module.spoke.spokeApplicationGatewaySubnetId
  appGatewayLogAnalyticsId        = module.spoke.logAnalyticsWorkspaceId
  appGatewayCertificatePath       = var.appGatewayCertificatePath
  logAnalyticsWorkspaceId         = module.spoke.logAnalyticsWorkspaceId
  tags                            = var.tags
}

module "serviceBus" {
  source = "./modules/service-bus"
  namespace_name = var.namespace_name
  topic_name = var.topic_name
  resourceGroupName = module.spoke.spokeResourceGroupName
  location = var.location
  sku = var.sku
  enable_partitioning = true
  create_subscription = true
  subscription_name = var.subscription_name
  max_delivery_count = var.max_delivery_count
  lock_duration = var.lock_duration
  tags = var.tags
}