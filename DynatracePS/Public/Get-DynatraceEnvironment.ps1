function Get-DynatraceEnvironment {
<#
    .SYNOPSIS
        Lists all environments and management zones of a Dynatrace account

    .DESCRIPTION
        Lists all environments and management zones of a Dynatrace account

    .EXAMPLE
        Get-DynatraceEnvironment

    .NOTES
        https://api.dynatrace.com/spec/#/Environment%20management/EnvironmentResourcesController_getEnvironmentResources
#>

    [CmdletBinding()]
    param()

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $AccountUuid = (Get-DynatracePSConfig).AccountUuid
        $RestPath = "/env/v1/accounts/$($AccountUuid)/environments"
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



