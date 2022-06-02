function New-DynatraceManagementZone {
<#
    .SYNOPSIS
        Create new Dynatrace Management Zone

    .DESCRIPTION
        Create new Dynatrace Management Zone

    .PARAMETER Name
        Name of the management zone
    
    .PARAMETER Description
        Description for the management zone

    .PARAMETER Rules
        One or more management zone rule objects
        See https://www.dynatrace.com/support/help/dynatrace-api/configuration-api/management-zones-api/post-mz#definition--MzRule

    .EXAMPLE
        $Rule = New-DynatraceMzRuleHostGroup -HostGroupName 'TEST_HG'
        New-DynatraceManagementZone -Name 'Test MZ' -Rules $Rule

        Create a new management zone named `Test MZ`, with a rule that maps TEST_HG host group to the new management zone

    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/configuration-api/management-zones-api/post-mz
#>

    [CmdletBinding(SupportsShouldProcess)]
    param(
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

        $Body = [ordered]@{
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

        # Second call is to actually create
        $splatParameters.Uri = $uri
        if ($PSCmdlet.ShouldContinue('Would you like to continue?',"Creating new management zone $Name")) {
            Invoke-DynatraceAPIMethod @splatParameters
        }
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}