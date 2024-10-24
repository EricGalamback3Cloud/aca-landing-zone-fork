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

resource "azurerm_container_app" "publisher" {
  name                         = "iot-publisher"
  resource_group_name          = data.terraform_remote_state.spoke.outputs.spokeResourceGroupName
  container_app_environment_id = data.terraform_remote_state.container_app_env.outputs.containerAppsEnvironmentId
  tags                         = var.tags
  workload_profile_name        = var.workloadProfileName

  identity {
    type         = "UserAssigned"
    identity_ids = [data.terraform_remote_state.supporting_services.outputs.containerRegistryUserAssignedIdentityId]
  }

  revision_mode = "Single"

  template {
    container {
      name   = "publisher"
      cpu    = "0.5"
      memory = "1Gi"
      image  = "${data.terraform_remote_state.supporting_services.outputs.containerRegistryName}.azurecr.io/iotpublisher:latest"
    }

    min_replicas = 1
    max_replicas = 10
  }

  dapr {
    app_id  = "iot-publisher"
  }
}

resource "azurerm_container_app" "publisher" {
  name                         = "iot-publisher2"
  resource_group_name          = data.terraform_remote_state.spoke.outputs.spokeResourceGroupName
  container_app_environment_id = data.terraform_remote_state.container_app_env.outputs.containerAppsEnvironmentId
  tags                         = var.tags
  workload_profile_name        = var.workloadProfileName

  identity {
    type         = "UserAssigned"
    identity_ids = [data.terraform_remote_state.supporting_services.outputs.containerRegistryUserAssignedIdentityId]
  }

  revision_mode = "Single"

  template {
    container {
      name   = "publisher"
      cpu    = "0.5"
      memory = "1Gi"
      image  = "crtfpocljgqvdeveus.azurecr.io/iotpublisher:latest"
    }

    min_replicas = 1
    max_replicas = 10
  }

  dapr {
    app_id  = "iot-publisher2"
  }
}

resource "azurerm_container_app" "subscriber" {
  name                         = "iot-subscriber"
  resource_group_name          = data.terraform_remote_state.spoke.outputs.spokeResourceGroupName
  container_app_environment_id = data.terraform_remote_state.container_app_env.outputs.containerAppsEnvironmentId
  tags                         = var.tags
  workload_profile_name        = var.workloadProfileName

  identity {
    type         = "UserAssigned"
    identity_ids = [data.terraform_remote_state.supporting_services.outputs.containerRegistryUserAssignedIdentityId]
  }

  revision_mode = "Single"

  template {
    container {
      name   = "subscriber"
      cpu    = "0.5"
      memory = "1Gi"
      image  = "${data.terraform_remote_state.supporting_services.outputs.containerRegistryName}.azurecr.io/iotsubscriber:latest"
    }

    min_replicas = 1
    max_replicas = 10
  }

  dapr {
    app_id  = "iot-subscriber"
    app_port = 8080
  }
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

