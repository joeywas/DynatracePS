function Get-DynatraceHostsInHostGroup {
<#
    .SYNOPSIS
        Get hosts in host group

    .DESCRIPTION
        Get hosts in host group

    .PARAMETER Id
        Unique id of the host group

    .PARAMETER Name
        Name of the host group

    .EXAMPLE
        Get-DynatraceHostsInHostGroup -Name HOST_GROUP_NAME

    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/environment-api/entity-v2/get-entity
#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ParameterSetName = 'id')]
        [string]$Id,
        [Parameter(Mandatory,ParameterSetName = 'name')]
        [string]$Name
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        if ($Name) {
            $Id = (Get-DynatraceHostGroup | Where-Object {$_.displayName -eq $Name}).entityID
        }
        $Output = @()
        $AllHosts = Get-DynatraceHost
    }

    process {
        $splatParm = @{
            entityID = $Id
        }
        $Properties = Get-DynatraceEntityProperty @splatParm
        foreach ($Host_ in $Properties.toRelationships.isInstanceOf) {
            $Output += [PSCustomObject]@{
                HostGroup = $Properties.displayName
                HostName = ($AllHosts | Where-Object{$_.entityID -eq $Host_.ID}).displayName
            }
        }
        $Output
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



