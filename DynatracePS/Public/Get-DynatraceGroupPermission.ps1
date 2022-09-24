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
        Get-DynatraceGroupPermission -groupUuid e5e9b12d-daf8-40d0-a6b5-7094667dd142 -OutputNotNested

    .EXAMPLE
        Get-DynatraceGroupPermission -GroupName 'Monitoring Viewer'
    
    .EXAMPLE
        Get-DynatraceGroup | %{Get-DynatraceGroupPermission -groupUuid $_.uuid}

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
                # caching management zones for lookup
                #
                $mz = Get-DynatraceManagementZone
                foreach ($permission in $result.permissions) {
                    if ($permission.scope -match ':') {
                        # if there is colon in permissions scope, it will be a string
                        # with environment name:management zone id
                        #
                        $splitPermissionScope = $permission.scope -split ':'
                        $mzName = ($mz | Where-Object{$_.ID -eq $splitPermissionScope[1]}).Name
                        $scope = "{0}:{1}" -f $splitPermissionScope[0],$mzName
                    } else {
                        $scope = $permission.scope;
                    }
                    $output += [pscustomobject]@{
                        uuid = $result.uuid;
                        name = $result.name;
                        owner = $result.owner;
                        description = $result.description;
                        hidden = $result.hidden;
                        createdAt = $result.createdAt;
                        updatedAt = $result.updatedAt;
                        permissionName = $permission.permissionName;
                        Scope = $scope;
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
            return
        }
    }
    end {
        $output
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



