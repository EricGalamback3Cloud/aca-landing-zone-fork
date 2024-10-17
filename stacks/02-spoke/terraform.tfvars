// The name of the workloard that is being deployed. Up to 10 characters long. This wil be used as part of the naming convention (i.e. as defined here: https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming) 
workloadName = "erictfpoc2"
environment = "dev"
tags        = {}
location = "eastus"
vmSize                   = "Standard_B2ms"
vmAdminUsername          = "vmadmin"
vmJumpboxOSType          = "Linux"
infraSubnetName          = "snet-infra"
vmLinuxAuthenticationType = "sshPublicKey"
vmJumpBoxSubnetAddressPrefix          = "10.1.2.32/27"
spokeVnetAddressPrefixes              = ["10.1.0.0/22"]