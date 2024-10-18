// The name of the workloard that is being deployed. Up to 10 characters long. This wil be used as part of the naming convention (i.e. as defined here: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming) 
workloadName = "erictfpoc2"
//The name of the environment (e.g. "dev", "test", "prod", "preprod", "staging", "uat", "dr", "qa"). Up to 8 characters long.
environment                           = "dev"
tags                                  = {}
location = "eastus"

helloWorldContainerAppName          = "ca-hello-world"
appGatewayCertificateKeyName        = "agwcert"
appGatewayFQDN                      = "acahello.demoapp.com"

namespace_name       = "galamback2"
topic_name           = "poc-topic"
sku                  = "Standard"
enable_partitioning  = true
create_subscription  = true
subscription_name    = "poc-subscription"
max_delivery_count   = 10
lock_duration        = "PT1M"
workloadProfileName  = "Consumption"