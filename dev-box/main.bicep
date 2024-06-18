@description('Dev Center Name')
param devcenterName string

@description('Project Name')
param projectName string

@description('Project Name')
param projectDescription string

@description('Definition Name')
param definitionName string

@description('Catalog Name')
param catalogName string

@description('Catalog repo Uri')
param repoUri string

@description('Catalog Branch')
param branch string

@description('Catalog path')
param path string

@description('Gallery Name')
param galleryName string

@description('OS Image name')
param image string

@description('Storage')
param storage string

@description('Network')
param virtualNetwork string

@description('Subnet')
param subnetName string

@description('Subnet creation')
param subnetsName array

@description('Subnet')
param vnetPrefix string

@description('Provide the AzureAd UserId to assign project rbac for (get the current user with az ad signed-in-user show --query id)')
param roleAssignments array

@description('The location of the resource')
param localAdministrator string

@description('The pool name')
param poolName string

@description('The pool name')
param networkConnectionName string

@description('The tags of the resource')
param tags object = {}

param location string = resourceGroup().location


// Deploy DevCenter
module devCenterInfra 'devcenter.bicep' = {
  name: 'DevCenterInfra'
  params: {
    location: location
    devcenterName: devcenterName
    tags: tags
  }
}

module devCenterProject 'project.bicep' = {
  name: 'DevCenterProject'
  dependsOn: [
    devCenterInfra
  ]
  params: {
    devcenterName: devcenterName
    projectName: projectName
    projectDescription: projectDescription
    tags: tags
  }
}

module devCenterCatalog 'catalog.bicep' = {
  name: 'DevCenterCatalog'
  dependsOn: [
    devCenterInfra
  ]
  params: {
    devcenterName: devcenterName
    catalogName: catalogName
    repoUri: repoUri
    branch: branch
    path: path
  }
}

module devCenterDefinitions 'definitions.bicep' = {
  name: 'DevCenterDefinitions'
  dependsOn: [
    devCenterInfra
  ]
  params: {
    devcenterName: devcenterName
    definitionName: definitionName
    galleryName: galleryName
    image: image
    storage: storage
  }
}

module devCenterNetwork 'vnet.bicep' = {
  name: 'DevCenterNetwork'
  params: {
    vnetName: virtualNetwork
    vnetPrefix: vnetPrefix
    vnetSubnets: subnetsName
    vNetTags: tags
  }
}

module devCenterNetworkConnection 'networkconnection.bicep' = {
  name: 'DevCenterNetworkConnection'
  dependsOn: [
    devCenterNetwork
  ]
  params: {
    devcenterName: devcenterName
    virtualNetwork: virtualNetwork
    subnetName: subnetName
    tags: tags
  }
}


module devCenterPools 'pools.bicep' = {
  name: 'DevCenterPools'
  dependsOn: [
    devCenterProject
  ]
  params: {
    projectname: projectName
    poolname: poolName
    definitionsname: definitionName
    networkConnectionName: networkConnectionName
    localAdministrator: localAdministrator
  }
}


module devCenterProjectRoleAssignment 'projectrbac.bicep' = {
  name: 'DevCenterProjectRoleAssignment'
  dependsOn: [
    devCenterProject
  ]
  params: {
    projectName: projectName
    roleAssignments: roleAssignments
  }
}
