function Get-DynatraceMetric {
<#
    .SYNOPSIS
        Get metrics from Dynatrace environment

    .DESCRIPTION
        Get metrics in Dynatrace environment

    .PARAMETER metricSelector
        Select metrics for the query by their keys. Example: builtin:*
        https://www.dynatrace.com/support/help/dynatrace-api/environment-api/metric-v2/get-all-metrics#parameters

    .PARAMETER text
        Metric registry search term. Only show metrics that contain the term in their key, display name, or description.

    .PARAMETER OutputAsJson
        Output the properties as a JSON string

    .EXAMPLE
        Get-DynatraceMetric -metricSelector builtin:*

    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/environment-api/metric-v2/get-all-metrics
#>

    [CmdletBinding()]
    param(
        [String]$metricSelector,
        [String]$text,
        [Switch]$outputAsJson
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID

        $uri = "https://$EnvironmentID.live.dynatrace.com/api/v2/metrics"

        # text and metricSelector are mutually exclusive, meaning
        # only one of these parameters may be used.
        if ($text) {
            $GetParameter = @{
                text = $text
            }
        } else {
            # if no metricSelector passed in, get all of them
            if (-not $metricSelector) {
                $metricSelector = '*'
            }
            $GetParameter = @{
                metricSelector = $metricSelector
            }
        }

        # Always set pageSize to a reasonable value?
        $GetParameter += @{
            pageSize = 200
        }

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
    }

    process {
        $splatParameters = @{
            Uri = $uri
            GetParameter = $GetParameter
            RestResponseProperty = 'metrics'
        }
        $output = Invoke-DynatraceAPIMethod @splatParameters
        if ($OutputAsJson) {
            $output | ConvertTo-Json -Depth 6
        } else {
            $output
        }
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



