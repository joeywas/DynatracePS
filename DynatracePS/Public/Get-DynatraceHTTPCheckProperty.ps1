function Get-DynatraceHTTPCheckProperty {
<#
    .SYNOPSIS
        Get properties for an http check

    .DESCRIPTION
        Get properties for an http check

    .PARAMETER Id
        Entity id of the http check

    .PARAMETER Name
        Name of the http check

    .PARAMETER OutputAsJson
        Output the properties as a JSON string

    .EXAMPLE
        Get-DynatraceHTTPCheckProperty -id entityid

    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/environment-api/entity-v2/get-entity
#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ParameterSetName = 'id')]
        [string]$Id,
        [Parameter(Mandatory,ParameterSetName = 'name')]
        [string]$Name,
        [switch]$OutputAsJson
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        if ($Name) {
            $Id = (Get-DynatraceHTTPCheck | Where-Object {$_.displayName -eq $Name}).entityID
        }
    }

    process {
        $splatParm = @{
            entityID = $Id
            OutputAsJson = $OutputAsJson
        }
        Get-DynatraceEntityProperty @splatParm
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



