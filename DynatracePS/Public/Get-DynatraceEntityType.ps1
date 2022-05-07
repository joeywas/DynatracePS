function Get-DynatraceEntityType {
<#
    .SYNOPSIS
        Get list of entity types in Dynatrace environment

    .DESCRIPTION
        Get list of entity types in Dynatrace environment

    .PARAMETER OutputAsJson
        Output the properties as a JSON string

    .EXAMPLE
        Get-DynatraceEntityType

    .NOTES
        https://api.dynatrace.com/spec/#/
#>

    [CmdletBinding()]
    param(
        [switch]$OutputAsJson
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID

        $uri = "https://$EnvironmentID.live.dynatrace.com/api/v2/entityTypes"

        $GetParameter = @{
            pageSize = 200
        }

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
    }
    process {
        $splatParameters = @{
            Uri = $uri
            GetParameter = $GetParameter
            RestResponseProperty = 'types'
        }
        $output = Invoke-DynatraceAPIMethod @splatParameters
        if ($OutputAsJson) {
            $output | ConvertTo-Json -Depth 6
        } else {
            $output
        }

    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



