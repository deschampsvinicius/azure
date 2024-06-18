@description('The project name')
param projectname string

@description('The pool name')
param poolname string

@description('The definitions name')
param definitionsname string = 'usedtaxidmadc01-win11-ssd_256gb'

@description('The location of the resource')
param location string = resourceGroup().location

@description('The location of the resource')
param networkConnectionName string

@description('The location of the resource')
param localAdministrator string

@description('The tags of the resource')
param tags object = {}

resource project 'Microsoft.DevCenter/projects@2023-04-01' existing = {
  name: projectname
}

resource pool 'Microsoft.DevCenter/projects/pools@2023-04-01' = {
  name: poolname
  location: location
  tags: tags
  parent: project
  properties: {
    devBoxDefinitionName: definitionsname
    licenseType: 'Windows_Client'
    localAdministrator: localAdministrator
    networkConnectionName: networkConnectionName
    stopOnDisconnect: {
      gracePeriodMinutes: 60
      status: 'Enabled'
    }
  }
}
