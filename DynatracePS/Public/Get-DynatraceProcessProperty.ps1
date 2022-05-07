function Get-DynatraceProcessProperty {
<#
    .SYNOPSIS
        Get a process's properties from Dynatrace environment

    .DESCRIPTION
        Get a process's properties from Dynatrace environment

    .PARAMETER Id
        Unique id of the process

    .PARAMETER Name
        Name of the process

    .PARAMETER OutputAsJson
        Output the properties as a JSON string

    .EXAMPLE
        Get-DynatraceProcessProperty -Id <process-id>

    .EXAMPLE
        Get-DynatraceProcessProperty -Name <process-name> -OutputAsJson

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
            $entityIds = (Get-DynatraceProcess | Where-Object {$_.displayName -eq $Name}).entityID
        } else {
            $entityIds = $Id
        }
    }

    process {
        foreach ($entityId in $entityIDs) {
            $splatParm = @{
                entityID = $entityId
                OutputAsJson = $OutputAsJson
            }
            Get-DynatraceEntityProperty @splatParm
        }
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



