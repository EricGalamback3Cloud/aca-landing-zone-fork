// The name of the workloard that is being deployed. Up to 10 characters long. This wil be used as part of the naming convention (i.e. as defined here: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming) 
workloadName = "tfpoc"
//The name of the environment (e.g. "dev", "test", "prod", "preprod", "staging", "uat", "dr", "qa"). Up to 8 characters long.
environment            = "dev"
location               = "eastus"
appInsightsName        = "appInsightsAca"
tags                   = {}
workloadProfiles = [{
  name                  = "general-purpose"
  workload_profile_type = "D4"
  minimum_count         = 1
  maximum_count         = 3
}]

namespace_name       = "galamback3"
topic_name           = "poc-topic"
sku                  = "Standard"
enable_partitioning  = true
create_subscription  = true
subscription_name    = "poc-subscription"