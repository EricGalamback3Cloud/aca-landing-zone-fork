resource "azurerm_servicebus_namespace" "sb" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  tags                = var.tags
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
