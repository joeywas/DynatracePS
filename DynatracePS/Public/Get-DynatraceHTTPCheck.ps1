function Get-DynatraceHTTPCheck {
<#
    .SYNOPSIS
        Get HTTP checks

    .DESCRIPTION
        Get HTTP Checks

    .EXAMPLE
        Get-DynatraceHTTPCheck

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
        Get-DynatraceEntity -Type 'HTTP_CHECK'
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



