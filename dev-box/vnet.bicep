@description('vnet name')
param vnetName string = 'vnet'
@description('vnet CIDR')
param vnetPrefix string = '192.168.5.0/24'
@description('vnet subnets')
param vnetSubnets array = []
@description('vnet tags')
param vNetTags object = {}
@description('vnet location, override if necessary, use default in most cases')
param vNetLocation string = resourceGroup().location

var tags = union(vNetTags, {
    Component : 'Network'
})

// vnet with subnets
resource vnet 'Microsoft.Network/virtualNetworks@2019-12-01' = {
  name: vnetName
  location: vNetLocation
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetPrefix
      ]
    }
    enableVmProtection: false
    enableDdosProtection: false
    subnets: [
      for subnet in vnetSubnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.prefix
        }
      }
    ]
  }
}
