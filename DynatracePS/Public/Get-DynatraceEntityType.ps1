function Get-DynatraceEntityType {
<#
    .SYNOPSIS
        Get list of entity types in Dynatrace environment

    .DESCRIPTION
        Get list of entity types in Dynatrace environment

    .PARAMETER Type
        Specific entity type to get properties for

    .PARAMETER OutputAsJson
        Output the properties as a JSON string

    .EXAMPLE
        Get-DynatraceEntityType

    .EXAMPLE
        Get-DynatraceEntityType -Type SERVICE

    .NOTES
        https://api.dynatrace.com/spec/#/
#>

    [CmdletBinding()]
    param(
        [string]$Type,
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

        if ($Type) {
            $uri = "https://$EnvironmentID.live.dynatrace.com/api/v2/entityTypes/$Type"
            $splatParameters = @{
                Uri = $uri
            }
        } else {
            $splatParameters = @{
                Uri = $uri
                GetParameter = $GetParameter
                RestResponseProperty = 'types'
            }    
        }

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
    }
    process {

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



