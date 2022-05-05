function Get-DynatraceEntity {
<#
    .SYNOPSIS
        Get entities in Dynatrace environment

    .DESCRIPTION
        Get entities in Dynatrace environment

    .PARAMETER Type
        The type of entity to get

    .EXAMPLE
        Get-DynatraceEntity -Type HOST_GROUP

    .NOTES
        https://api.dynatrace.com/spec/#/
#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$Type
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID

        $uri = "https://$EnvironmentID.live.dynatrace.com/api/v2/entities"

        $GetParameter = @{
            entitySelector = "type(`"$Type`")"
            pageSize = 200
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



