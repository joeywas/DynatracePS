function Get-DynatraceUserGroup {
<#
    .SYNOPSIS
        List the groups for a user

    .DESCRIPTION
        List the groups for a user

    .PARAMETER OutputAsJson
        Output the properties as a JSON string

    .EXAMPLE
        Get-DynatraceUserGroup -Email name@domain.com

    .NOTES
        https://api.dynatrace.com/spec/#/User%20management/UsersController_getUserGroups

#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$Email,
        [switch]$OutputAsJson
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
            $splatParameters = @{
                RestPath =$RestPath
                OutputAsJson = $OutputAsJson
            }
            Invoke-DynatraceAccountManagementAPIMethod @splatParameters
        } catch {
            $_
            return
        }
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}
