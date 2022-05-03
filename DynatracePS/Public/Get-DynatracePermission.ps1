function Get-DynatracePermission {
<#
    .SYNOPSIS
        Lists all available permissions

    .DESCRIPTION
        Lists all available permissions

    .EXAMPLE
        Get-DynatracePermission

    .NOTES
        https://api.dynatrace.com/spec/#/Reference%20data/ReferenceDataController_getPermissions
#>

    [CmdletBinding()]
    param()

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $RestPath = "/ref/v1/account/permissions"
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



