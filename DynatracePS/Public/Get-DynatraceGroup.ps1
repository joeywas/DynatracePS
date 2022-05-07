function Get-DynatraceGroup {
<#
    .SYNOPSIS
        List the groups on a Dynatrace account

    .DESCRIPTION
        List the groups on a Dynatrace account

    .PARAMETER OutputAsJson
        Output the properties as a JSON string
        
    .EXAMPLE
        Get-DynatraceGroup

    .NOTES
        https://api.dynatrace.com/spec/#/Group%20management/GroupsController_getGroups
#>

    [CmdletBinding()]
    param(
        [switch]$OutputAsJson
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $AccountUuid = (Get-DynatracePSConfig).AccountUuid
        $RestPath = "/iam/v1/accounts/$($AccountUuid)/groups"
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
            break
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



