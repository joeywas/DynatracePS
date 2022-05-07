function Get-DynatraceEffectivePermission {
<#
    .SYNOPSIS
        Gets effective permissions for a user or group

    .DESCRIPTION
        Gets effective permissions for a user or group

    .PARAMETER levelType
        The type of the policy level. Valid values: account or environment

    .PARAMETER levelId
        The ID of the policy level. for account, use the UUID of the account. For environment, use the ID of the environment.

    .PARAMETER entityType
        The entity type. Valid values: user or group

    .PARAMETER entityId
        The entity id

    .PARAMETER OutputAsJson
        Output the properties as a JSON string
        
    .EXAMPLE
        Get-DynatraceEffectivePermission -levelType account -levelID <accountUuid>

    .EXAMPLE
        Get-DynatraceEffectivePermission -levelType environment -levelID <environment id>

    .NOTES
        https://api.dynatrace.com/spec/#/Policy%20management/PolicyController_getEffectivePermissions
#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('account','environment')]
        [String]$levelType,
        [Parameter(Mandatory)]
        [String]$levelID,
        [String]$entityType,
        [String]$entityId,
        [switch]$explain,
        [switch]$OutputAsJson
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $RestPath = "/iam/v1/resolution/$levelType/$levelID/effectivepermissions"
        $UrlParameters = "?entityType=$entityType&entityID=$entityID&explain=$explain"
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] RestPath: $RestPath"
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] URLParameters: $URLParameters"
        $path = "$RestPath$URLParameters"
    }

    process {
        try {
            $splatParameters = @{
                RestPath =$path
                OutputAsJson = $OutputAsJson
            }
            Invoke-DynatraceAccountManagementAPIMethod @splatParameters
        } catch {
            $_
            break
        }
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



