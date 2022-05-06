function Get-DynatraceManagementZoneProperty {
<#
    .SYNOPSIS
        Get properties of a management zone in Dynatrace environment

    .DESCRIPTION
        Get properties of a management zone in Dynatrace environment

    .PARAMETER Id
        The unique id of the management zone. Required if not using name
    
    .PARAMETER Name 
        The name of the management zone. Required if not using id

    .PARAMETER OutputAsJson
        Output the management zone properties as Json

    .EXAMPLE
        Get-DynatraceManagementZoneProperty -id 1234554321

        Get management zone properties associated with management zone with id of 1234554321. 

    .EXAMPLE
        Get-DynatraceManagementZoneProperty -Name PROD_WINDOWS -OutputAsJson

        Get management zone properties for the management zone named PROD_WINDOWS and output them as json

    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/configuration-api/management-zones-api/get-mz
#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ParameterSetName = 'id')]
        [string]$id,
        [Parameter(Mandatory,ParameterSetName = 'name')]
        [string]$Name,
        [switch]$OutputAsJson
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        if ($Name) {
            $id = (Get-DynatraceManagementZone | Where-Object {$_.Name -eq $Name}).id
        }

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID
        $uri = "https://$EnvironmentID.live.dynatrace.com/api/config/v1/managementZones/$id"

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
    }

    process {
        $splatParameters = @{
            Uri = $uri
        }
        $output = Invoke-DynatraceAPIMethod @splatParameters

        if ($OutputAsJson) {
            $output | ConvertTo-Json -Depth 6
        } else {
            $output
        }
        
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



