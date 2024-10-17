// The name of the workloard that is being deployed. Up to 10 characters long. This wil be used as part of the naming convention (i.e. as defined here: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming) 
workloadName = "erictfpoc2"
//The name of the environment (e.g. "dev", "test", "prod", "preprod", "staging", "uat", "dr", "qa"). Up to 8 characters long.
environment = "dev"
tags        = {}
location = "eastus"

spokeVnetAddressPrefixes              = ["10.1.0.0/22"]
vmJumpBoxSubnetAddressPrefix          = "10.1.2.32/27"
infraSubnetAddressPrefix              = "10.1.0.0/27"
privateEndpointsSubnetAddressPrefix   = "10.1.2.0/27"
applicationGatewaySubnetAddressPrefix = "10.1.3.0/24"

vmSize                   = "Standard_B2ms"
vmAdminUsername          = "vmadmin"
vmJumpboxOSType          = "Linux"
infraSubnetName          = "snet-infra"
vmLinuxAuthenticationType = "sshPublicKey"
