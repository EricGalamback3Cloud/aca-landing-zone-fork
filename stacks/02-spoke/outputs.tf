output "spokeResourceGroupName" {
  value = module.spoke.spokeResourceGroupName
}

output "spokeVNetId" {
  value = module.spoke.vnetId
}

output "spokePrivateEndpointsSubnetId" {
  value = module.spoke.spokePrivateEndpointsSubnetId
}

output "logAnalyticsWorkspaceId" {
  value = module.spoke.logAnalyticsWorkspaceId
}