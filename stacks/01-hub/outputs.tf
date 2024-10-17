
output "hubResourceGroupName" {
  value = module.hub.hubResourceGroupName
}

output "hubVnetId" {
  description = "The resource ID of hub virtual network."
  value       = module.hub.hubVnetId
}

output "firewallPrivateIp" {
  description = "The private IP address of the firewall."
  value       = module.hub.firewallPrivateIp
}

output "hubVnetName" {
  value = module.hub.hubVnetName
}