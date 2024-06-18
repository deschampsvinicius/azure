@description('Project Name')
param projectName string

@description('Provide the AzureAd UserId to assign project rbac for (get the current user with az ad signed-in-user show --query id)')
param roleAssignments array


resource project 'Microsoft.DevCenter/projects@2023-04-01' existing = {
  name: projectName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for roleAssignment in roleAssignments: {
  name: guid(project.id, roleAssignment.roleID, roleAssignment.principalID)
  scope: project
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleID)
    principalId: roleAssignment.principalID
    principalType: roleAssignment.principalType
  }
}]
