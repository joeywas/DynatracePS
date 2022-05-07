function Get-DynatraceHost {
<#
    .SYNOPSIS
        Gets hosts in Dynatrace environment

    .DESCRIPTION
        Gets hosts in Dynatrace environment

    .EXAMPLE
        Get-DynatraceHost

    .NOTES
        https://awa35000.live.dynatrace.com/rest-api-doc/index.jsp?urls.primaryName=Environment%20API%20v2#/Monitored%20entities/getEntities
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



