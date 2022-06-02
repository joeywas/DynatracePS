function Remove-DynatraceManagementZone {
<#
    .SYNOPSIS
        Remove the specified Management Zone

    .DESCRIPTION
        Remove the specified Management Zone

    .PARAMETER ID
        Entity ID of the management zone to remove. Required if not using Name
    
    .PARAMETER Name
        Name of the management zone to remove. Required if not using ID
    
    .EXAMPLE
        Remove-DynatraceManagementZone -Name 'Test MZ'

    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/configuration-api/management-zones-api/del-mz
#>

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,ParameterSetName = 'id')]
        [string]$id,
        [Parameter(Mandatory,ParameterSetName = 'name')]
        [string]$Name
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        if ($Name) {
            $id = (Get-DynatraceManagementZone | Where-Object {$_.Name -eq $Name}).id
        } else {
            $Name = (Get-DynatraceManagementZone | Where-Object {$_.id -eq $id}).Name
        }

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID
        
        $uri = "https://$EnvironmentID.live.dynatrace.com/api/config/v1/managementZones/$id"

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] $Uri"
    }

    process {

        # First call is to validator URL -- this confirms the payload is valid
        $splatParameters = @{
            Uri = $uri
            Method = 'DELETE'
        }
        Write-Debug "[$($MyInvocation.MyCommand.Name)] splatParameters: $($splatParameters | Out-String)"

        if ($PSCmdlet.ShouldContinue('Would you like to continue?',"Remove management zone $Name")) {
            Invoke-DynatraceAPIMethod @splatParameters
        }
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}