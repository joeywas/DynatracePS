function Get-DynatraceSettingsSchema {
<#
    .SYNOPSIS
        Get list of settings schemas in Dynatrace environment

    .DESCRIPTION
        Get list of settings schemas in Dynatrace environment

    .EXAMPLE
        Get-DynatraceSettingsSchema

    .NOTES
        https://api.dynatrace.com/spec/#/
#>

    [CmdletBinding()]
    param()

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID

        $uri = "https://$EnvironmentID.live.dynatrace.com/api/v2/settings/schemas"

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
    }

    process {
        $splatParameters = @{
            Uri = $uri
            RestResponseProperty = 'items'
        }
        Invoke-DynatraceAPIMethod @splatParameters
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



