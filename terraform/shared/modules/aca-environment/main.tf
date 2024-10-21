data "azurerm_client_config" "current" {}

resource "azurerm_container_app_environment" "environment" {
  name                           = var.environmentName
  resource_group_name            = var.resourceGroupName
  location                       = var.location
  log_analytics_workspace_id     = var.logAnalyticsWorkspaceId
  infrastructure_subnet_id       = var.subnetId
  internal_load_balancer_enabled = true

  dynamic "workload_profile" {
    for_each = var.workloadProfiles

    content {
      name                  = workload_profile.value.name
      workload_profile_type = workload_profile.value.workload_profile_type
      minimum_count         = workload_profile.value.minimum_count
      maximum_count         = workload_profile.value.maximum_count
    }
  }

  lifecycle {
    ignore_changes = [ 
      id
     ]
  }
}

resource "azurerm_container_app_environment_dapr_component" "pubsub" {
    count = 1
  
    name                         = var.serviceBusDaprComponentName
    container_app_environment_id = azurerm_container_app_environment.main.id
    component_type               = "pubsub.azure.servicebus"
    version                      = "v1"
    #scopes                       = var.messaging_dapr_scopes
  
    metadata {
      name  = "namespaceName"
      value = "${var.serviceBusNamespace}.servicebus.windows.net"
    }
  
    metadata {
      name  = "azureClientId"
      #value = azurerm_user_assigned_identity.main.client_id
      value = data.azurerm_client_config.current.object_id
    }
}
  