Function New-DynatraceMzRuleHostGroup {
<#
	.SYNOPSIS
		Output a management zone rule object for a host group

	.DESCRIPTION
        Output a management zone rule object for mapping host group to a management zone
    
    .PARAMETER HostGroupID
        Entity ID of the host group for the rule

    .PARAMETER HostGroupName
        Host group name, will be used to look up the entity ID of the hose group
    
    .NOTES
        This page contains the format of what the rule object should look like:
        https://www.dynatrace.com/support/help/dynatrace-api/configuration-api/management-zones-api/post-mz#example
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        [string]$HostGroupID,
        [string]$HostGroupName
    )
    begin {
        $output = @{}
        if ($HostGroupName) {
            $HostGroupID = (Get-DynatraceHostGroup | Where-Object {$_.DisplayName -eq $HostGroupName}).entityID
        }
        $conditions = @()
    }
    process {

        $conditions += (
            [ordered]@{
                key = [ordered]@{
                    attribute = 'HOST_GROUP_ID'
                    type = 'STATIC'
                }
                comparisonInfo = [ordered]@{
                    type = 'ENTITY_ID'
                    operator = 'EQUALS'
                    value = $HostGroupID
                    negate = $false
                }
            }
        )

        $output = [ordered]@{
            type = 'HOST'
            enabled = $true
            propagationTypes = @()
            conditions = $conditions
        }
    } # end process
    end {
        $output
    }
}