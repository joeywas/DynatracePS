function Get-DynatraceNotification {
<#
    .SYNOPSIS
        Lists all notification configurations available in your environment

    .DESCRIPTION
        Lists all notification configurations available in your environment

    .PARAMETER id
        Optional, id of notification to get details for

    .PARAMETER OutputAsJson
        Optional, output the properties as a JSON string

    .EXAMPLE
        Get-DynatraceNotification

    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/configuration-api/notifications-api/get-all-notifications
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

        $uri = "https://$EnvironmentID.live.dynatrace.com/api/config/v1/notifications"

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



