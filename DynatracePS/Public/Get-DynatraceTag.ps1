function Get-DynatraceTag {
<#
    .SYNOPSIS
        Get tags in Dynatrace environment

    .DESCRIPTION
        Get tags in Dynatrace environment

    .PARAMETER entitySelector
        The entity selector string to get the tags for. Example: 'type("HOST")'

    .EXAMPLE
        Get-DynatraceTag -entitySelector 'type("HOST")'

        Get all the tags for HOST entities

    .EXAMPLE
        Get-DynatraceTag -entitySelector 'type("HOST_GROUP")'

        Get all the tags for HOST_GROUP entities
    
    .EXAMPLE
        Get-DynatraceTag -entitySelector 'entityId("123456789")'

        Get the tags associated with entity with ID of 123456789

    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/environment-api/custom-tags/get-tags
#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$entitySelector
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID

        $uri = "https://$EnvironmentID.live.dynatrace.com/api/v2/tags"

        $GetParameter = @{
            entitySelector = $entitySelector
        }

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
    }

    process {
        $splatParameters = @{
            Uri = $uri
            GetParameter = $GetParameter
            #RestResponseProperty = 'tags'
        }
        Invoke-DynatraceAPIMethod @splatParameters
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



