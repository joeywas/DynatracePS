function Get-DynatraceEnvironment {
<#
    .SYNOPSIS
        Lists all environments and management zones of a Dynatrace account

    .DESCRIPTION
        Lists all environments and management zones of a Dynatrace account

    .PARAMETER OutputAsJson
        Output the properties as a JSON string
        
    .EXAMPLE
        Get-DynatraceEnvironment

    .NOTES
        https://api.dynatrace.com/spec/#/Environment%20management/EnvironmentResourcesController_getEnvironmentResources
#>

    [CmdletBinding()]
    param(
        [switch]$OutputAsJson
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $AccountUuid = (Get-DynatracePSConfig).AccountUuid
        $RestPath = "/env/v1/accounts/$($AccountUuid)/environments"
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
            break
        }
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



