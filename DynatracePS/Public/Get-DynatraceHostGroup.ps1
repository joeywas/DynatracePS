function Get-DynatraceHostGroup {
<#
    .SYNOPSIS
        Get host groups in Dynatrace environment

    .DESCRIPTION
        Get host groups in Dynatrace environment

    .EXAMPLE
        Get-DynatraceHostGroup

    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/environment-api/entity-v2
#>

    [CmdletBinding()]
    param()

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process {
        Get-DynatraceEntity -Type 'HOST_GROUP'
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



