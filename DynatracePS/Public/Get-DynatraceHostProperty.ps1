function Get-DynatraceHostProperty {
<#
    .SYNOPSIS
        Get properties for a host

    .DESCRIPTION
        Get properties for a host

    .PARAMETER Id
        Unique id of the host

    .PARAMETER Name
        Name of the host

    .PARAMETER OutputAsJson
        Output the properties as a JSON string

    .EXAMPLE
        Get-DynatraceHostProperty -id hostid

    .EXAMPLE
        Get-DynatraceHostProperty -Name hostname -OutputAsJson

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
            $Id = (Get-DynatraceHost | Where-Object {$_.displayName -eq $Name}).entityId
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Got $Name entityID value of $Id"
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



