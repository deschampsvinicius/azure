<#
  .SYNOPSIS
  This script performs the migration from Azure Service Bus Standard to Premium.
  
  .DESCRIPTION
  This PowerShell script performs a specific task, the migration of Service Bus Standard to Premium.
  
  .PARAMETER resourceGroup
  Specifies the name of the Azure Resource Group where the Azure Service Bus Standard (source) is located.
  
  .PARAMETER standardNamespace
  Specifies the name of the Azure Service Bus Standard (source).
  
  .PARAMETER targetNamespace
  Specifies the name of the Azure Service Bus Premium (target).
  
  .PARAMETER postMigrationDnsName
  Specifies the value of the DNS to be used to access the Azure Service Bus Standard post-migration. It's already defined in the script
  
  .EXAMPLE
  Example 1:
  .\migrate-azure-service-bus-standard-to-premium.ps1 -resourceGroupName "YourResourceGroup" -standardNamespace "AzureServiceBusStandardName" -targetNamespace "AzureServiceBusPremiumName"
  
  .NOTES
  Author: Vinicius
  Date: 2024-02-01
  Version: 1.0
#>

param (
    [Parameter(Mandatory = $true)]
    [string]
    $resourceGroupName,
    [Parameter(Mandatory = $true)]
    $standardNamespace,
    [Parameter(Mandatory = $true)]
    $targetNamespace
)

$postMigrationDnsName = $standardNamespace+$targetNamespace

Write-Host "Initiating the migration from $($standardNamespace) to $($targetNamespace)"

az servicebus migration start --resource-group $resourceGroupName --name $standardNamespace --target-namespace $targetNamespace --post-migration-name $postMigrationDnsName --output none
if (!$?) {
    Write-Host "Migration failed"
    Write-Host $_
    exit 1
}

Write-Host "Checking migration"

$checkMigration = az servicebus migration show --resource-group $resourceGroupName --name $standardNamespace | ConvertFrom-Json
    
while ($checkMigration.provisioningState -ne "Succeeded") {
    $checkMigration = az servicebus migration show --resource-group $resourceGroupName --name $standardNamespace | ConvertFrom-Json
}

if ($checkMigration.migrationState -eq "Active" -And $checkMigration.provisioningState -eq "Succeeded" -And $checkMigration.pendingReplicationOperationsCount -eq "0") {
    az servicebus migration complete --resource-group $resourceGroupName --name $standardNamespace
    if (!$?) {
        exit 1
    }
    Write-Host "Migration completed"
}
