function Get-DynatraceSubscription {
<#
    .SYNOPSIS
        Lists all Dynatrace platform subscriptions of an account

    .DESCRIPTION
        Lists all Dynatrace platform subscriptions of an account

    .PARAMETER OutputAsJson
        Output the properties as a JSON string
        
    .EXAMPLE
        Get-DynatraceSubscription

    .NOTES
        https://api.dynatrace.com/spec/#/Dynatrace%20platform%20subscription/LimaClaController_getClaSubscriptions
#>

    [CmdletBinding()]
    param(
        [switch]$OutputAsJson
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $AccountUuid = (Get-DynatracePSConfig).AccountUuid
        $RestPath = "/sub/v1/accounts/$($AccountUuid)/subscriptions"
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $RestPath"
    }

    process {
        try {
            $splatParameters = @{
                RestPath =$RestPath
                OutputAsJson = $OutputAsJson
            }
            $return = Invoke-DynatraceAccountManagementAPIMethod @splatParameters
        } catch {
            $_
            break
        }
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Count of results: $($return.totalCount)"
        if ($OutputAsJson) {
            $return | ConvertTo-Json -Depth 6
        } else {
            $return.records
        }
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



