function Get-DynatraceHTTPCheckStatus {
<#
    .SYNOPSIS
        Get results of all HTTP check monitor executions

    .DESCRIPTION
        Get results of all HTTP check monitor executions

    .PARAMETER All
        Get all records, not just the latest ones

    .EXAMPLE
        Get-DynatraceHTTPCheckStatus

        Return the most recent failed execution for all http check synthetic monitors

    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/environment-api/synthetic-v2/synthetic-monitor-execution/get-http-monitor
#>

    [CmdletBinding()]
    param(
        [Switch]$All
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $HTTPChecks = Get-DynatraceHTTPCheck
        $SyntheticLocations = Get-DynatraceSyntheticLocation
        $Output = @()
    }

    process {

        foreach ($HTTPCheck in $HTTPChecks) {
            $SuccessResults = Get-DynatraceHTTPCheckMonitorExecution -monitorID $HTTPCheck.entityID -resultType SUCCESS
            $FailedResults = Get-DynatraceHTTPCheckMonitorExecution -monitorID $HTTPCheck.entityID -resultType FAILED

            foreach ($location in $SuccessResults.locationsExecutionResults) {
                $Output += [PSCustomObject]@{
                    MonitorName = $HTTPCheck.displayName
                    Location = ($SyntheticLocations | Where-Object {$_.ID -eq $location.locationId}).Name
                    ResponseStatusCode = $location.requestResults.ResponseStatusCode
                    ResponseMessage = $location.requestResults.ResponseMessage
                    HealthStatus = $location.requestResults.healthStatus
                    StartTime = (ConvertTo-Datetime $location.requestResults.startTimestamp)
                    WaitingTime = $location.requestResults.waitingTime
                }    
            }
            foreach ($location in $FailedResults.locationsExecutionResults) {
                $Output += [PSCustomObject]@{
                    MonitorName = $HTTPCheck.displayName
                    Location = ($SyntheticLocations | Where-Object {$_.ID -eq $location.locationId}).Name
                    ResponseStatusCode = $location.requestResults.ResponseStatusCode
                    ResponseMessage = $location.requestResults.ResponseMessage
                    HealthStatus = $location.requestResults.healthStatus
                    StartTime = (ConvertTo-Datetime $location.requestResults.startTimestamp)
                    WaitingTime = $location.requestResults.waitingTime
                }    
            }
        }
        if ($All) {
            $Output
        } else {
            $Output | Group-Object MonitorName | Foreach-Object {$_.Group | Sort-Object StartTime | Select-Object -Last 1}
        }
        
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



