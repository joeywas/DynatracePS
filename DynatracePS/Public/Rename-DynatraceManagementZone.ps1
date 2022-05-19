function Rename-DynatraceManagementZone {
<#
    .SYNOPSIS
        Rename a Management zone

    .DESCRIPTION
        Rename a Management zone

    .PARAMETER Id
        The unique id of the management zone to rename. Required if not using name
    
    .PARAMETER Name 
        The name of the management zone to rename. Required if not using id

    .PARAMETER NewName
        The new name of the management zone.

    .EXAMPLE
        Rename-DynatraceManagementZone -id 1234554321 -NewName 'MANAGEMENT_ZONE_1'

    .EXAMPLE
        Rename-DynatraceManagementZone -Name 'MANAGEMENT_ZONE' -NewName 'MANAGEMENT_ZONE_1'

    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/configuration-api/management-zones-api/get-mz
#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ParameterSetName = 'id')]
        [string]$id,
        [Parameter(Mandatory,ParameterSetName = 'name')]
        [string]$Name,
        [Parameter(Mandatory)]
        [string]$NewName
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID
        $baseUri = "https://$EnvironmentID.live.dynatrace.com/api/config/v1/managementZones"

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] baseUri: $baseUri"
    }

    process {

        # If name was used, we need the mz id
        #
        if ($Name) {
            $id = (Get-DynatraceManagementZone | Where-Object {$_.Name -eq $Name}).id
        }

        $ExistingMZ = Get-DynatraceManagementZoneProperty -id $id 
        $ExistingMZ.Name = $NewName
        $body = $ExistingMZ | ConvertTo-Json -Depth 5

        $uri = "$baseUri/$id"
        $validatorUri = "$uri/validator"

        # Validate the payload
        $splatParameters = @{
            Uri = $validatorUri
            Body = $body
            Method = 'Post'
            ContentType = 'application/json'
        }
        Invoke-DynatraceAPIMethod @splatParameters

        # it passed, do the actual post
        $splatParameters = @{
            Uri = $Uri
            Body = $body
            Method = 'Put'
            ContentType = 'application/json'
        }
        Invoke-DynatraceAPIMethod @splatParameters       
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}