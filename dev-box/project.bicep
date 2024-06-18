@description('The dev center name')
param devcenterName string

@description('The project name')
param projectName string

@description('The project name')
param projectDescription string = ''

@description('The location of the resource')
param location string = resourceGroup().location

@description('The tags of the resource')
param tags object = {}

resource devcenter 'Microsoft.DevCenter/devcenters@2023-04-01' existing = {
  name: devcenterName
}

resource project 'Microsoft.DevCenter/projects@2023-04-01' = {
  name: projectName
  location: location
  tags: tags
  properties: {
    devCenterId: devcenter.id
    description: projectDescription
  }
}
