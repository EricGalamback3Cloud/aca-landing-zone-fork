module "serviceBus" {
  source               = "../../../../shared/terraform/modules/service-bus"
  namespace_name       = var.namespace_name
  topic_name           = var.topic_name
  resource_group_name  = module.spoke.spokeResourceGroupName
  location             = var.location
  sku                  = var.sku
  enable_partitioning  = true
  create_subscription  = true
  subscription_name    = var.subscription_name
  max_delivery_count   = var.max_delivery_count
  lock_duration        = var.lock_duration
  tags                 = var.tags
}