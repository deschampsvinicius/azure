@description('Create a new catalog in the specified Dev Center')
param devcenterName string

@description('The name of the catalog')
param catalogName string

@description('The URI of the GitHub repository')
param repoUri string

@description('The branch of the GitHub repository')
param branch string = 'main'

@description('The path of the GitHub repository where the catalog is located')
param path string

resource devcenter 'Microsoft.DevCenter/devcenters@2023-04-01' existing = {
  name: devcenterName
}

resource catalog 'Microsoft.DevCenter/devcenters/catalogs@2023-04-01' = {
  name: catalogName
  parent: devcenter
  properties: {
    gitHub: {
      branch: branch
      path: path
      uri: repoUri
    }
  }
}
