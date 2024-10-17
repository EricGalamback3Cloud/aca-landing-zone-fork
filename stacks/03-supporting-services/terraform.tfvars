


deployHelloWorldSample              = true
supportingResourceGroupName         = "kat-supporting-services"
aRecords                            = []
containerRegistryPullRoleAssignment = "acrRoleAssignment"
keyVaultPullRoleAssignment          = "keyVaultRoleAssignment"
appInsightsName                     = "appInsightsAca"
helloWorldContainerAppName          = "ca-hello-world"
appGatewayCertificateKeyName        = "agwcert"
appGatewayFQDN                      = "acahello.demoapp.com"

workloadProfiles = [{
  name                  = "general-purpose"
  workload_profile_type = "D4"
  minimum_count         = 1
  maximum_count         = 3
}]

namespace_name       = "galamback"
topic_name           = "poc-topic"
sku                  = "Standard"
enable_partitioning  = true
create_subscription  = true
subscription_name    = "poc-subscription"
max_delivery_count   = 10
lock_duration        = "PT1M"