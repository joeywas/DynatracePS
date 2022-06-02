function Update-DynatraceManagementZone {
<#
    .SYNOPSIS
        Update the specified Management Zone

    .DESCRIPTION
        Update the specified Management Zone

    .PARAMETER ID
        Entity ID of the management zone to update. Required if not using Name
    
    .PARAMETER Name
        Name of the management zone to update. Required if not using ID
    
    .PARAMETER Description
        Updated description for the management zone

    .PARAMETER Rules
        One or more management zone rule objects
        See https://www.dynatrace.com/support/help/dynatrace-api/configuration-api/management-zones-api/post-mz#definition--MzRule

    .EXAMPLE
        $Rule = New-DynatraceMzRuleHostGroup -HostGroupName 'TEST_HG'
        New-DynatraceManagementZone -Name 'Test MZ' -Rules $Rule

        Create a new management zone named `Test MZ`, with a rule that maps TEST_HG host group to the new management zone

    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/configuration-api/management-zones-api/put-mz
#>

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,ParameterSetName = 'id')]
        [string]$id,
        [Parameter(Mandatory,ParameterSetName = 'name')]
        [string]$Name,
        [string]$Description,
        [PSCustomObject]$Rules
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID
        
        $uri = "https://$EnvironmentID.live.dynatrace.com/api/config/v1/managementZones"
        $uriValidator = "$uri/validator"

        $Headers = @{
            'Content-Type' = 'application/json'
        }

        if ($Name) {
            $id = (Get-DynatraceManagementZone | Where-Object {$_.Name -eq $Name}).id
        } else {
            $Name = (Get-DynatraceManagementZone | Where-Object {$_.id -eq $id}).Name
        }

        $Body = [ordered]@{
            id = $id
            name = $Name
            rules = @($Rules)
        }
        $JsonBody = $Body | ConvertTo-Json -Depth 10

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
    }

    process {

        # First call is to validator URL -- this confirms the payload is valid
        $splatParameters = @{
            Uri = $uriValidator
            Method = 'POST'
            Body = $JsonBody
            Headers = $Headers
        }
        Invoke-DynatraceAPIMethod @splatParameters

        # Second call is to actually update
        $splatParameters.Uri = $uri
        $splatParameters.Method = 'PUT'

        if ($PSCmdlet.ShouldContinue('Would you like to continue?',"Update management zone $Name")) {
            Invoke-DynatraceAPIMethod @splatParameters
        }
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}