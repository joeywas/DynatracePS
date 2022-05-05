function Get-DynatraceContainer {
<#
    .SYNOPSIS
        Gets containers in Dynatrace environment

    .DESCRIPTION
        Gets containers in Dynatrace environment

    .EXAMPLE
        Get-DynatraceContainer

    .NOTES
        https://api.dynatrace.com/spec/#/
#>

    [CmdletBinding()]
    param()

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID

        $uri = "https://$EnvironmentID.live.dynatrace.com/api/v2/entities"

        $GetParameter = @{
            entitySelector = 'type("CONTAINER_GROUP_INSTANCE")'
            pageSize = 500
        }

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
    }

    process {
        $splatParameters = @{
            Uri = $uri
            GetParameter = $GetParameter
            RestResponseProperty = 'entities'
        }
        Invoke-DynatraceAPIMethod @splatParameters
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



