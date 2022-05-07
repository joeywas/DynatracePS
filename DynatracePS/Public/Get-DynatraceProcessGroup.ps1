function Get-DynatraceProcessGroup {
<#
    .SYNOPSIS
        Get process groups in Dynatrace environment

    .DESCRIPTION
        Get process groups in Dynatrace environment

    .EXAMPLE
        Get-DynatraceProcessGroup

    .NOTES
        https://www.dynatrace.com/support/help/how-to-use-dynatrace/process-groups

#>

    [CmdletBinding()]
    param()

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process {
        Get-DynatraceEntity -Type 'PROCESS_GROUP'
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



