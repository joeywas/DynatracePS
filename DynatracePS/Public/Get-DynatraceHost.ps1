function Get-DynatraceHost {
<#
    .SYNOPSIS
        Gets hosts in Dynatrace environment

    .DESCRIPTION
        Gets hosts in Dynatrace environment

    .EXAMPLE
        Get-DynatraceHost

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
        Get-DynatraceEntity -Type 'HOST'
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



