function Get-DynatraceProcess {
<#
    .SYNOPSIS
        Get list of monitored processes from Dynatrace environment

    .DESCRIPTION
        Get list of monitored processes from Dynatrace environment

    .EXAMPLE
        Get-DynatraceProcess

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
        Get-DynatraceEntity -Type 'PROCESS_GROUP_INSTANCE'
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



