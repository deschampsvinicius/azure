<#
.SYNOPSIS
This script separate the cost of Azure SQL Server, Azure SQL Elastic Pool and databases.

.DESCRIPTION
This PowerShell script performs a specific task, to show the separate cost of Azure SQL Server, Elastic Pool and standalone databases.

.EXAMPLE
Example 1:
.\get-azure-cost-subscription-sql-separation.ps1 
This command executes the powershell script, and shows the output on the screen.

.NOTES
Author: Vinicius
Date: 2024-01-22
Version: 1.0
#>

# Define $month as last Mont (e.g. If today is January, it is going to get December)
$month = [datetime]::Today.AddMonths(-1).ToString('yyyyMM')

# Get all resources from the current context
$resources =  Get-AzResource

foreach ($resource in $resources) { # go resource by resource
    $resourceCost = 0
    if ($resource.type -like "Microsoft.Sql/servers*") { # checks if the $resource.type has "Microsoft.Sql/servers" on it
        $resourceUsage =  Get-AzConsumptionUsageDetail  -InstanceName ($resource.name -split "/")[0] -Expand MeterDetails -BillingPeriodName $month
        foreach ($usage in $resourceUsage) { # go for every cost captured in the $resourceUsage variable
            if ($Usage.InstanceName -eq $resource.name) { # checks if it's the SQL Server
                $resourceCost += $usage.PretaxCost
            }
            elseif ($usage.InstanceName -eq ($resource.name -split "/")[1]) { # otherwise it will check for the Elastic Pool or Databases to get the cost
                $resourceCost += $usage.PretaxCost
            }
        }
    }
    else { # in case it is not a SQL Server type, it captures the cost to show in the screen too
        $resourceUsage =  Get-AzConsumptionUsageDetail  -InstanceName $resource.name -Expand MeterDetails -BillingPeriodName $month
        foreach ($usage in $resourceUsage) {
            $resourceCost += $usage.PretaxCost
        }
    }
    Write-Host "In $($month), $($resource.name) had a cost of: $($resourceCost)"
}
