function Get-DynatracePermission {
<#
    .SYNOPSIS
        Lists all available permissions

    .DESCRIPTION
        Lists all available permissions

    .PARAMETER OutputAsJson
        Output the properties as a JSON string    

    .EXAMPLE
        Get-DynatracePermission

    .NOTES
        https://api.dynatrace.com/spec/#/Reference%20data/ReferenceDataController_getPermissions
#>

    [CmdletBinding()]
    param(
        [switch]$OutputAsJson
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $RestPath = "/ref/v1/account/permissions"
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



