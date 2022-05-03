function Get-DynatraceSubscription {
<#
    .SYNOPSIS
        Lists all Dynatrace platform subscriptions of an account

    .DESCRIPTION
        Lists all Dynatrace platform subscriptions of an account

    .EXAMPLE
        Get-DynatraceSubscription

    .NOTES
        https://api.dynatrace.com/spec/#/Dynatrace%20platform%20subscription/LimaClaController_getClaSubscriptions
#>

    [CmdletBinding()]
    param()

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $AccountUuid = (Get-DynatracePSConfig).AccountUuid
        $RestPath = "/sub/v1/accounts/$($AccountUuid)/subscriptions"
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $RestPath"
    }

    process {
        try {
            $return = Invoke-DynatraceAccountManagementAPIMethod -RestPath $RestPath
        } catch {
            $_
            break
        }
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Count of results: $($return.totalCount)"
        $return.records
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



