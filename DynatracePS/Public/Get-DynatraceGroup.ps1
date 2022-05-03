function Get-DynatraceGroup {
<#
    .SYNOPSIS
        List the groups on a Dynatrace account

    .DESCRIPTION
        List the groups on a Dynatrace account

    .EXAMPLE
        Get-DynatraceGroup

    .NOTES
        https://api.dynatrace.com/spec/#/Group%20management/GroupsController_getGroups
#>

    [CmdletBinding()]
    param()

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $AccountUuid = (Get-DynatracePSConfig).AccountUuid
        $RestPath = "/iam/v1/accounts/$($AccountUuid)/groups"
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $RestPath"
    }

    process {
        try {
            $return = Invoke-DynatraceAccountManagementAPIMethod -RestPath $RestPath
        } catch {
            $_
            break
        }
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Count of results: $($return.count)"
        $return.items
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



