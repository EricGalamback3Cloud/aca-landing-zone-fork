resource "azurerm_servicebus_namespace" "sb" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  tags                = var.tags
  public_network_access_enabled = var.public_network_access_enabled
  capacity = 1
  premium_messaging_partitions = 1
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
  name = azurerm_servicebus_namespace.sb.name + "pe"
  resource_group_name = var.resource_group_name
  subnet_id = var.subnetId
  tags = var.tags
  private_service_connection {
    is_manual_connection = false
    name = azurerm_servicebus_namespace.sb.name + "conn"
    private_connection_resource_id = azurerm_servicebus_namespace.sb.id
    subresource_names = ["namespace"]
  }

  private_dns_zone_group {
    name = "dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns_zone.id]
  }
  depends_on = [ azurerm_servicebus_namespace.sb ]
}

resource "azurerm_private_dns_zone" "dns_zone" {
  name                = "privatelink.servicebus.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = "vnet-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.vnet_link.name
  virtual_network_id    = var.virutal_network_id
}
