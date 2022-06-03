function Get-DynatraceGroupPermission {
<#
    .SYNOPSIS
        List all permissions for a single user group

    .DESCRIPTION
        List all permissions for a single user group

    .PARAMETER GroupUuid
        The UUID of a user group

    .PARAMETER GroupName
        The name of a group

    .PARAMETER OutputNotNested
        Set to make it so output is not nested, helpful for exporting to excel

    .PARAMETER OutputAsJson
        Output the properties as a JSON string
        
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
        [String]$GroupName,
        [switch]$OutputNotNested,
        [switch]$OutputAsJson
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
        $output = @()
    }

    process {
        try {
            $splatParameters = @{
                RestPath =$RestPath
                OutputAsJson = $OutputAsJson
            }
            $result = Invoke-DynatraceAccountManagementAPIMethod @splatParameters

            if ($OutputNotNested) {
                foreach ($permission in $result.permissions) {
                    $output += [pscustomobject]@{
                        uuid = $result.uuid;
                        name = $result.name;
                        owner = $result.owner;
                        description = $result.description;
                        hidden = $result.hidden;
                        createdAt = $result.createdAt;
                        updatedAt = $result.updatedAt;
                        permissionName = $permission.permissionName;
                        Scope = $permission.scope;
                        ScopeType = $permission.scopeType;
                        permissionCreatedAt = $permission.createdAt;
                        permissionUpdatedAt = $permission.updatedAt;
                    }
                }
            } else {
                $output = $result
            }
        } catch {
            $_
            break
        }
    }
    end {
        $output
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



