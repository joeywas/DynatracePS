function Get-DynatraceHost {
<#
    .SYNOPSIS
        Gets hosts in Dynatrace environment

    .DESCRIPTION
        Gets hosts in Dynatrace environment

    .EXAMPLE
        Get-DynatraceHost

    .NOTES
        https://api.dynatrace.com/spec/#/
#>

    [CmdletBinding()]
    param()

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process {
        $output = @()
        $hosts = Get-DynatraceEntity -Type 'HOST'

        foreach ($host in $hosts) {
            $eps = Get-DynatraceEntityProperty -entityID $host.entityID
            $properties = $eps.properties
            $hostgroupID = ($eps.fromRelationships.isInstanceOf | where-object {$_.type -eq 'HOST_GROUP'}).id
            $hostgroup = Get-DynatraceHostGroup | Where-Object {$_.entityID -eq $hostgroupID}
            $item = [PSCustomObject]@{
                entityID = $host.entityID
                displayName = $host.displayName
                detectedName = $properties.detectedName
                hostgroup = $hostgroup.displayName
                monitoringMode = $properties.monitoringMode
                state = $properties.state
                ipAddress = $properties.ipAddress[0]
                osArchitecture = $properties.osArchitecture
                osType = $properties.osType
                osVersion = $properties.osVersion
            }
            $output += $item
        }
        $output
    } # end process
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



