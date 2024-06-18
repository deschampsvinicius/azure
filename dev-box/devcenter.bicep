@description('The dev center name')
param devcenterName string

@description('The location to deploy the dev center to')
param location string = resourceGroup().location

@description('The tags to apply to the dev center')
param tags object = {}


resource devcenter 'Microsoft.DevCenter/devcenters@2023-04-01' = {
  name: devcenterName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
}


