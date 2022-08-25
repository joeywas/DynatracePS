function Get-DynatraceAuditLog {
<#
    .SYNOPSIS
        Get audit logs

    .DESCRIPTION
        Get audit logs

    .PARAMETER From
        Start of the requested time frame. Defaults to now-2h
        There are several recognized formats available, see:
        https://www.dynatrace.com/support/help/shortlink/api-problems-v2-get-list#parameters

    .PARAMETER To
        End of the requested time frame. Defaults to current timestamp
        There are several recognized formats available, see:
        https://www.dynatrace.com/support/help/shortlink/api-problems-v2-get-list#parameters

    .PARAMETER OutputAsJson
        Optional, output the properties as a JSON string

    .EXAMPLE
        Get-DynatraceAuditLog

    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/environment-api/audit-logs/get-log
#>

    [CmdletBinding()]
    param(
        [string]$From,
        [string]$To,
        [Switch]$outputAsJson
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID

        $uri = "https://$EnvironmentID.live.dynatrace.com/api/v2/auditlogs"

        $GetParameter = @{}
        if ($from) {
            $GetParameter += @{from = $from}
        }
        if ($to) {
            $GetParameter += @{to = $to}
        }

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
    }

    process {
        $splatParameters = @{
            Uri = $uri
            GetParameter = $GetParameter
            RestResponseProperty = 'auditLogs'
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



