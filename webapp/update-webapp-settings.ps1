<#
.SYNOPSIS
This script does update the App Settings of Azure Web App / Azure Functions without removing the other existing settings.

.DESCRIPTION
This PowerShell script performs a specific task, such as configuring settings in an Azure Web App.

.PARAMETER resourceGroup
Specifies the name of the Azure Resource Group where the Web App is located.

.PARAMETER webapp
Specifies the name of the Azure Web App to work with.

.PARAMETER appSettingName
Specifies the name of the App Setting parameter to be added/updated.

.PARAMETER appSettingValue
Specifies the value of the App Setting parameter to be added/updated.

.EXAMPLE
Example 1:
.\update-webapp-settings.ps1 -resourceGroup "YourResourceGroup" -resourceGroup "YourResourceGroup" -appSettingName "YourAppSettingName" -appSettingValue "YourAppSettingValue"
This command configures the settings for the specified Azure Web App.

.NOTES
Author: Vinicius
Date: 2023-11-02
Version: 1.0
#>

param (
    $resourceGroup,
    $webappName,
    $appSettingName,
    $appSettingValue
)

foreach ($webapp in $webappName) {
    
    $getWebAppSettings = (Get-AzWebApp -Name $webapp -ResourceGroupName $resourceGroup).SiteConfig.AppSettings

    $newAppSetting = new-object Microsoft.Azure.Management.WebSites.Models.NameValuePair
    $newAppSetting.Name = $appSettingName
    $newAppSetting.Value = $appSettingValue

    if ($getWebAppSettings.Name.Contains($newAppSetting.Name)) {
        $getWebAppSettings = $getWebAppSettings | ForEach-Object {
            if ($_.Name -eq $appSettingName) {
                $_ = $newAppSetting
            }
            $_
        }
    }
    else {
        $getWebAppSettings += $newAppSetting
    }

    $updateAppSettings = @{}
    $getWebAppSettings | ForEach-Object {
        $updateAppSettings[$_.Name] = $_.Value
    }

    Set-AzWebApp -ResourceGroupName $resourceGroup -Name $webappname  -AppSettings $updateAppSettings
}
