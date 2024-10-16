output "servicebus_namespace_id" {
  description = "The ID of the created Service Bus namespace."
  value       = azurerm_servicebus_namespace.sb.id
}

output "servicebus_topic_id" {
  description = "The ID of the created Service Bus topic."
  value       = azurerm_servicebus_topic.sbTopic.id
}

output "servicebus_subscription_id" {
  value = var.create_subscription && length(azurerm_servicebus_subscription.sbSubscription) > 0 ? azurerm_servicebus_subscription.sbSubscription[0].id : null
  description = "The ID of the Service Bus subscription if it exists."
}