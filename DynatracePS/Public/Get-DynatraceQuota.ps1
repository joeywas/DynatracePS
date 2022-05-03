function Get-DynatraceQuota {
<#
    .SYNOPSIS
        Gets the host units quota of a Dynatrace account

    .DESCRIPTION
        Gets the host units quota of a Dynatrace account

    .EXAMPLE
        Get-DynatraceQuote

    .NOTES
        https://api.dynatrace.com/spec/#/Quota%20management/QuotaController_getQuota
#>

    [CmdletBinding()]
    param()

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $AccountUuid = (Get-DynatracePSConfig).AccountUuid
        $RestPath = "/env/v1/accounts/$($AccountUuid)/quotas/host-monitoring"
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $RestPath"
    }

    process {
        try {
            $return = Invoke-DynatraceAccountManagementAPIMethod -RestPath $RestPath
        } catch {
            $_
            break
        }
        $return
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



