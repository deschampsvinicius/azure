@description('Dev Center Name')
param devcenterName string

@description('Netwok that already exists')
param virtualNetwork string

@description('Subnet that already exists')
param subnetName string

param location string = resourceGroup().location

@description('The tags to apply to the dev center')
param tags object = {}

@description('The name of a new resource group that will be created to store some Networking resources (like NICs) in')
param networkingResourceGroupName string = '${resourceGroup().name}-${devcenterName}-${location}'

resource devcenter 'Microsoft.DevCenter/devcenters@2023-04-01' existing = {
  name: devcenterName
}

resource vnet 'Microsoft.Network/virtualNetworks@2019-12-01' existing = {
  name: virtualNetwork
}


resource networkconnection 'Microsoft.DevCenter/networkConnections@2023-04-01' = {
  name: 'dcon-${devcenterName}-${location}'
  location: location
  tags: tags
  properties: {
    domainJoinType: 'AzureADJoin'
    subnetId: '${vnet.id}/subnets/${subnetName}'
    networkingResourceGroupName: networkingResourceGroupName
  }
}

resource attachedNetwork 'Microsoft.DevCenter/devcenters/attachednetworks@2023-04-01' = {
  name: 'dcon-${devcenterName}-${location}'
  parent: devcenter
  properties: {
    networkConnectionId: networkconnection.id
  }
}
