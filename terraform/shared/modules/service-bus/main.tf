resource "azurerm_servicebus_namespace" "sb" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  tags                = var.tags
  public_network_access_enabled = var.public_network_access_enabled
}

resource "azurerm_servicebus_topic" "sbTopic" {
  name                = var.topic_name
  namespace_id        = azurerm_servicebus_namespace.sb.id
}

resource "azurerm_servicebus_subscription" "sbSubscription" {
  count               = var.create_subscription ? 1 : 0
  name                = var.subscription_name
  topic_id            = azurerm_servicebus_topic.sbTopic.id
  max_delivery_count  = var.max_delivery_count
  lock_duration       = var.lock_duration
}

resource "azurerm_private_endpoint" "pe" {
  location = var.location
  #name = var.sevicebus_private_endpoint_name
  name = "asb-pe2"
  resource_group_name = var.resource_group_name
  subnet_id = var.subnetId
  tags = var.tags
  private_service_connection {
    is_manual_connection = false
    #name = var.servicebus_private_endpoint_connection_name + "pe"
    name = "asb-pe2-plc"
    private_connection_resource_id = "/subscriptions/d5736eb1-f851-4ec3-a2c5-ac8d84d029e2/resourceGroups/rg-tfpoc-spoke-dev-eus/providers/Microsoft.ServiceBus/namespaces/galamback7"
    subresource_names = ["namespace"]
  }
  depends_on = [ azurerm_servicebus_namespace.sb ]
}

