function Get-DynatraceAlertingProfile {
<#
    .SYNOPSIS
        Get alerting profile(s) available in your Dynatrace environment

    .DESCRIPTION
        Get alerting profile(s) available in your Dynatrace environment

    .PARAMETER id
        Optional, id of alerting profile to get details for

    .PARAMETER OutputAsJson
        Optional, output the properties as a JSON string

    .EXAMPLE
        Get-DynatraceAlertingProfile 

    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/configuration-api/alerting-profiles-api/get-all
#>

    [CmdletBinding()]
    param(
        [string]$id,
        [Switch]$outputAsJson
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID

        $uri = "https://$EnvironmentID.live.dynatrace.com/api/config/v1/alertingProfiles"

        if ($id) {
            $uri = "$uri/$id"
        } else {
            $RestResponseProperty = 'values'
        }

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
    }

    process {
        $splatParameters = @{
            Uri = $uri
            RestResponseProperty = $RestResponseProperty
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



