function Get-DynatraceGroupUser {
<#
    .SYNOPSIS
        List all members of a group on a Dynatrace account

    .DESCRIPTION
        List all members of a group on a Dynatrace account

    .PARAMETER GroupUuid
        The UUID of the user group

    .PARAMETER GroupName
        The Name of the group

    .PARAMETER OutputAsJson
        Output the properties as a JSON string
        
    .EXAMPLE
        Get-DynatraceGroupUser -groupUuid e5e9b12d-daf8-40d0-a6b5-7094667dd142

    .EXAMPLE
        Get-DynatraceGroupUser -GroupName 'Monitoring Viewer'

    .NOTES
        https://api.dynatrace.com/spec/#/Group%20management/GroupsController_getUsersForGroup

#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ParameterSetName = 'Uuid')]
        [String]$groupUuid,
        [Parameter(Mandatory,ParameterSetName = 'Name')]
        [String]$GroupName,
        [switch]$OutputAsJson
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $AccountUuid = (Get-DynatracePSConfig).AccountUuid

        if ($GroupName) {
            $groupUuid = (Get-DynatraceGroup | Where-Object{$_.Name -eq $GroupName}).Uuid
        }
        $RestPath = "/iam/v1/accounts/$AccountUuid/groups/$groupUuid/users"
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
            return
        }
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Count of results: $($return.count)"
        if ($OutputAsJson) {
            $return
        } else {
            $return.items
        }
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



