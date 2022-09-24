function Get-DynatraceSettingsSchema {
<#
    .SYNOPSIS
        Get settings schemas in Dynatrace environment. Returns list if no schemaid value is passed in

    .PARAMETER SchemaID
        The ID of the required schema. Optional.

    .PARAMETER OutputAsJson
        Output the properties as a JSON string

    .EXAMPLE
        Get-DynatraceSettingsSchema

        Get list of Setting schemas

    .EXAMPLE
        Get-DynatraceSettingsSchema -SchemaID builtin:custom-metrics

        Get the builtin:custom-metrics schema id

    .NOTES
        https://api.dynatrace.com/spec/#/
        https://www.dynatrace.com/support/help/dynatrace-api/environment-api/settings/schemas/get-schema
#>

    [CmdletBinding()]
    param(
        [string]$SchemaID,
        [switch]$OutputAsJson
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID

        $uri = "https://$EnvironmentID.live.dynatrace.com/api/v2/settings/schemas"

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
    }

    process {
        if ($SchemaID) {
            $uri = "$uri/$SchemaID"
            $RestResponseProperty = $null
        } else {
            $RestResponseProperty = 'items'
        }

        $splatParameters = @{
            Uri = $uri
            RestResponseProperty = $RestResponseProperty
        }
        try {
            $output = Invoke-DynatraceAPIMethod @splatParameters
        } catch {
            $_
            return
        }
        
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