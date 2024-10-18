locals {
  defaultSubnets = [
    {
      name            = var.infraSubnetName
      addressPrefixes = tolist([var.infraSubnetAddressPrefix])
    },
    {
      name            = var.privateEndpointsSubnetName
      addressPrefixes = tolist([var.privateEndpointsSubnetAddressPrefix])
    }
  ]

  appGatewayandDefaultSubnets = var.applicationGatewaySubnetAddressPrefix != "" ? concat(
    local.defaultSubnets,
    [{
      name            = var.applicationGatewaySubnetName
      addressPrefixes = tolist([var.applicationGatewaySubnetAddressPrefix])
    }]
  ) : local.defaultSubnets

  spokeSubnets = var.vmJumpboxOSType != "none" ? concat(
    local.appGatewayandDefaultSubnets,
    [{
      name            = var.jumpboxSubnetName
      addressPrefixes = tolist([var.jumpboxSubnetAddressPrefix])
    }]
  ) : local.appGatewayandDefaultSubnets

  subnetDelegations = {
    "${var.infraSubnetName}" = {
      "Microsoft.App/environments" = {
        service_name = "Microsoft.App/environments"
        service_actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action"
        ]
      }
    }
  }
}
