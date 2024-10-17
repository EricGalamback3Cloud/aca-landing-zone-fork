
output "hubResourceGroupName" {
  value = module.hub.hubResourceGroupName
}

output "hubVnetId" {
  description = "The resource ID of hub virtual network."
  value       = module.vnet.vnetId
}

output "firewallPrivateIp" {
  description = "The private IP address of the firewall."
  value       = module.firewall.firewallPrivateIp
}