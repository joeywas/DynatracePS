function Get-DynatraceGroupPermission {
<#
    .SYNOPSIS
        List all permissions of a user group

    .DESCRIPTION
        List all permissions of a user group

    .PARAMETER GroupUuid
        The UUID of a user group

    .PARAMETER GroupName
        The name of a group

    .EXAMPLE
        Get-DynatraceGroupPermission -groupUuid e5e9b12d-daf8-40d0-a6b5-7094667dd142

    .EXAMPLE
        Get-DynatraceGroupPermission -GroupName 'Monitoring Viewer'

    .NOTES
        https://api.dynatrace.com/spec/#/Group%20management/GroupsController_getUsersForGroup

#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ParameterSetName = 'Uuid')]
        [String]$groupUuid,
        [Parameter(Mandatory,ParameterSetName = 'Name')]
        [String]$GroupName
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $AccountUuid = (Get-DynatracePSConfig).AccountUuid

        if ($GroupName) {
            $groupUuid = (Get-DynatraceGroup | Where-Object{$_.Name -eq $GroupName}).Uuid
        }
        $RestPath = "/iam/v1/accounts/$AccountUuid/groups/$groupUuid/permissions"
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



