output "servicebus_namespace_id" {
  description = "The ID of the created Service Bus namespace."
  value       = azurerm_servicebus_namespace.this.id
}

output "servicebus_topic_id" {
  description = "The ID of the created Service Bus topic."
  value       = azurerm_servicebus_topic.this.id
}

output "servicebus_subscription_id" {
  value = var.create_subscription && length(azurerm_servicebus_subscription.this) > 0 ? azurerm_servicebus_subscription.this[0].id : null
  description = "The ID of the Service Bus subscription if it exists."
}