function Get-DynatraceEntityProperty {
<#
    .SYNOPSIS
        Get properties for a specified entity in Dynatrace environment

    .DESCRIPTION
        Get properties for a specified entity in Dynatrace environment

    .PARAMETER entityID
        The entity ID

    .EXAMPLE
        Get-DynatraceEntityProperty -entityID HOST-9FADEDA85A24F460

    .NOTES
        https://api.dynatrace.com/spec/#/
#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$entityID
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID

        $uri = "https://$EnvironmentID.live.dynatrace.com/api/v2/entities/$entityID"

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
    }

    process {
        $splatParameters = @{
            Uri = $uri
        }
        Invoke-DynatraceAPIMethod @splatParameters
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



