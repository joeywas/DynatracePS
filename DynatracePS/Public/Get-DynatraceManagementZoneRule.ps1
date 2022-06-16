function Get-DynatraceManagementZoneRule {
<#
    .SYNOPSIS
        Get rules associated with a management zone in Dynatrace environment

    .DESCRIPTION
        Get rules associated with a management zone in Dynatrace environment

    .PARAMETER Id
        The unique id of the management zone. Required if not using name
    
    .PARAMETER Name 
        The name of the management zone. Required if not using id

    .EXAMPLE
        Get-DynatraceManagementZoneRule -id 1234554321

        Get management zone rules associated with management zone with id of 1234554321. 

    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/configuration-api/management-zones-api/get-mz
#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ParameterSetName = 'id')]
        [string]$id,
        [Parameter(Mandatory,ParameterSetName = 'name')]
        [string]$Name
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
        $output = @()
    }

    process {
        $return = Get-DynatraceManagementZoneProperty -id $id
        foreach ($rule in $return.Rules) {
            # using a for loop because the key is in one property
            # and the comparisons are in a different property
            #
            for ($i = 0; $i -lt ($rule.conditions).Count; $i++) {
                $condition = $rule.conditions[$i]
                $comparisonType = $condition.comparisonInfo.Type
                
                if ($condition.key.dynamicKey) {
                    $key = $condition.key.dynamicKey
                } elseif ($condition.key.attribute) {
                    $key = $condition.key.attribute
                } else {
                    $key = ''
                }
                if ($comparisonType -eq 'TAG') {
                    $comparisonType = "TAG:$($condition.comparisonInfo.value.key)"
                    $value = "$($condition.comparisonInfo.value.value)"
                } elseif ($comparisonType -eq 'SIMPLE_TECH') {
                    $comparisonType = "TECH:$($condition.comparisonInfo.value.type)"
                } else {
                    $comparisonType = ''
                    $value = $condition.comparisonInfo.value
                }
                $output += [PSCustomObject]@{
                    ManagementZoneName = $return.name
                    RuleType = $rule.Type
                    Enabled = $rule.enabled
                    Key = $key
                    ComparisonType = $comparisonType
                    Operator = $condition.comparisonInfo.operator
                    ComparisonValue = $value
                    Negate = $condition.comparisonInfo.negate
                }
            }
        }
        $output
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



