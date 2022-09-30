function Get-DynatraceSettingsObject {
<#
    .SYNOPSIS
        Get settings object(s)

    .DESCRIPTION
        Get settings object(s)

    .PARAMETER objectID
        Object ID string to get.

    .PARAMETER SchemaIDs
        Schema IDs to which the requested objects belong. Use Get-DynatraceSettingsSchema to get SchemaIDs

    .PARAMETER Scopes
        Scopes to get settings objects for. e.g. environment

    .PARAMETER OutputAsJson
        Output the properties as a JSON string

    .EXAMPLE
        Get-DynatraceSettingsobject -scopes 'environment'

    .EXAMPLE
        Get-DynatraceSettingsobject -schemaid 'builtin:management-zones' -OutputAsJson

        Get settings for the management zones schemaid and output as json

    .NOTES
        https://api.dynatrace.com/spec/#/
        https://www.dynatrace.com/support/help/dynatrace-api/environment-api/settings/objects/get-objects
#>

    [CmdletBinding()]
    param(
        [string]$objectID,
        [string[]]$SchemaIDs,
        [string[]]$scopes,
        [switch]$OutputAsJson
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID

        $uri = "https://$EnvironmentID.live.dynatrace.com/api/v2/settings/objects"

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
    }

    process {

        if ($SchemaIDs) {
            $GetParameter = @{schemaIds = $SchemaIDs -join ','}
            $RestResponseProperty = 'items'
        } elseif ($scopes) {
            $GetParameter = @{scopes = $scopes -join ','}
            $RestResponseProperty = 'items'
        } elseif ($objectID) {
            $uri = "$uri/$objectID"
            $GetParameter = $null
            $RestResponseProperty = $null
        } else {
            Write-Warning 'One of the following parameters must be used: -SchemaIds, -scopes, -objectID'
            Write-Warning 'Exiting...'
            return
        }

        $splatParameters += @{
            Uri = $uri
            GetParameter = $GetParameter
            RestResponseProperty = $RestResponseProperty
        }

        try {
            $output = Invoke-DynatraceAPIMethod @splatParameters
        } catch {
            $_
            return
        }
        
        if ($OutputAsJson) {
            $output | ConvertTo-Json -Depth 10
        } else {
            $output
        }
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}