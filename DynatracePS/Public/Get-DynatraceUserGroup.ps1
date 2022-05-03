function Get-DynatraceUserGroup {
<#
    .SYNOPSIS
        List the groups for a user

    .DESCRIPTION
        List the groups for a user

    .EXAMPLE
        Get-DynatraceUserGroup -Email name@domain.com

    .NOTES
        https://api.dynatrace.com/spec/#/User%20management/UsersController_getUserGroups

#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$Email
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $AccountUuid = (Get-DynatracePSConfig).AccountUuid
        $RestPath = "/iam/v1/accounts/$($AccountUuid)/users/$Email"
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
