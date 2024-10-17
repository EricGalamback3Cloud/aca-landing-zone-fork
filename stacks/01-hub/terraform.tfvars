// The name of the workloard that is being deployed. Up to 10 characters long. This wil be used as part of the naming convention (i.e. as defined here: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming) 
workloadName = "erictfpoc2"
//The name of the environment (e.g. "dev", "test", "prod", "preprod", "staging", "uat", "dr", "qa"). Up to 8 characters long.
environment = "dev"
tags        = {}
location = "eastus"

hubVnetAddressPrefixes                     = ["10.0.0.0/24"]
gatewaySubnetAddressPrefix                 = "10.0.0.0/27"
azureFirewallSubnetAddressPrefix           = "10.0.0.64/26"
bastionSubnetAddressPrefixes               = ["10.0.0.128/26"]
azureFirewallSubnetManagementAddressPrefix = "10.0.0.192/26"
infraSubnetAddressPrefix              = "10.1.0.0/27"
applicationGatewaySubnetAddressPrefix = "10.1.3.0/24"
enableBastion            = true