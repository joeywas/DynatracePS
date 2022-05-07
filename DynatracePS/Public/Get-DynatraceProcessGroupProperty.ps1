function Get-DynatraceProcessGroupProperty {
<#
    .SYNOPSIS
        Get process group properties from Dynatrace environment

    .DESCRIPTION
        Get process group properties from Dynatrace environment

    .PARAMETER Id
        Unique id of the process group

    .PARAMETER Name
        Name of the process group

    .PARAMETER OutputAsJson
        Output the properties as a JSON string

    .EXAMPLE
        Get-DynatraceProcessGroupProperty -Id <process-group-id>

    .EXAMPLE
        Get-DynatraceProcessGroupProperty -Name <process-group-name> -OutputAsJson

    .NOTES
        https://www.dynatrace.com/support/help/how-to-use-dynatrace/process-groups

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
            $entityIds = (Get-DynatraceProcessGroup | Where-Object {$_.displayName -eq $Name}).entityID
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



