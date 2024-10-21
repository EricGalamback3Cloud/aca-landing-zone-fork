// The name of the workloard that is being deployed. Up to 10 characters long. This wil be used as part of the naming convention (i.e. as defined here: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming) 
workloadName = "tfpoc"
//The name of the environment (e.g. "dev", "test", "prod", "preprod", "staging", "uat", "dr", "qa"). Up to 8 characters long.
environment                           = "dev"
tags                                  = {}
location = "eastus"

helloWorldContainerAppName          = "ca-hello-world"
appGatewayCertificateKeyName        = "agwcert"
appGatewayFQDN                      = "acahello.demoapp.com"

max_delivery_count   = 10
lock_duration        = "PT1M"
workloadProfileName  = "Consumption"