function Get-DynatraceHTTPCheckMonitorExecution {
<#
    .SYNOPSIS
        Get results of HTTP check monitor executions

    .DESCRIPTION
        Get results of HTTP check monitor executions

    .PARAMETER monitorID
        monitorID (entityID) identifier for which last execution result is returned

    .PARAMETER resultType
        SUCCESS or FAILED

    .EXAMPLE
        Get-DynatraceHTTPCheckMonitorExecution -monitorID HTTP_CHECK-0123456789ABCDEF -resultType SUCCESS

        Return the most recent SUCCESS execution for HTTP_CHECK-0123456789ABCDEF

    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/environment-api/synthetic-v2/synthetic-monitor-execution/get-http-monitor
#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$monitorID,
        [Parameter(Mandatory)][ValidateSet('SUCCESS','FAILED')]
        [string]$resultType
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID
        $baseUri = "https://$EnvironmentID.live.dynatrace.com/api/v2/synthetic/execution/$monitorID/"
    }

    process {
        $uri = "$($baseUri)$resultType"
        Invoke-DynatraceAPIMethod -Uri $uri
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}