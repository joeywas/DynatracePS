function Get-DynatraceSyntheticLocation {
<#
    .SYNOPSIS
        Lists all locations, public and private, and their parameters available for your environment

    .DESCRIPTION
        Lists all locations, public and private, and their parameters available for your environment
        Access token must have Read synthetic locations (syntheticLocations.read) scope.

    .PARAMETER Type
        Get only locations of the specified type. May be PUBLIC or PRIVATE. Optional.

    .EXAMPLE
        Get-DynatraceSyntheticLocation

    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/environment-api/synthetic-v2/synthetic-locations-v2/get-all-locations
#>

    [CmdletBinding()]
    param(
        [string]$Type
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID

        $locationsUri = "https://$EnvironmentID.live.dynatrace.com/api/v2/synthetic/locations"

        if ($Type) {
            $GetParameter = @{
                type = $Type.ToUpper()
            }
        }
        $output = @()
    }

    process {
        $splatParameters = @{
            Uri = $locationsUri
            RestResponseProperty = 'locations'
            GetParameter = $GetParameter
        }
        $results = Invoke-DynatraceAPIMethod @splatParameters
        foreach ($result in $results) {
            # Get the decimal value from the hex in the entityID
            #
            $id = [uint64]($result.entityID -replace 'SYNTHETIC_LOCATION-','0x')
            # Add it to the result
            #
            $result | Add-Member -MemberType NoteProperty -Name 'ID' -Value $id
            $result
        }
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



