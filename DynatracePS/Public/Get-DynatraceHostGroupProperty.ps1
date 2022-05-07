function Get-DynatraceHostGroupProperty {
<#
    .SYNOPSIS
        Get properties for a host group

    .DESCRIPTION
        Get properties for a host group

    .PARAMETER Id
        Unique id of the host group

    .PARAMETER Name
        Name of the host group

    .PARAMETER OutputAsJson
        Output the properties as a JSON string

    .EXAMPLE
        Get-DynatraceHostGroupProperty -id hostgroupid

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
            $Id = (Get-DynatraceHostGroup | Where-Object {$_.displayName -eq $Name}).entityID
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



