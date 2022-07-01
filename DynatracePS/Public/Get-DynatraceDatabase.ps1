function Get-DynatraceDatabase {
<#
    .SYNOPSIS
        Get Database services in Dynatrace environment

    .DESCRIPTION
        Get Database services in Dynatrace environment

    .PARAMETER Name
        Return databases that contain Name

    .EXAMPLE
        Get-DynatraceDatabase

    .EXAMPLE
        Get-DynatraceDatabase -Name ORT

        Return all database services that have ORT in the Name

    .NOTES
        https://api.dynatrace.com/spec/#/
        https://www.dynatrace.com/support/help/dynatrace-api/environment-api/entity-v2/entity-selector
#>

    [CmdletBinding()]
    param(
        [String]$Name
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID

        $uri = "https://$EnvironmentID.live.dynatrace.com/api/v2/entities"

        $entitySelector = "type(`"SERVICE`"),serviceType(`"DATABASE_SERVICE`")"

        if ($Name) {
            $entitySelector = "$entitySelector,entityName(`"$Name`")"
        }

        $GetParameter = @{
            entitySelector = $entitySelector
            pageSize = 200
        }

        $output = @()

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
    }

    process {
        $splatParameters = @{
            Uri = $uri
            GetParameter = $GetParameter
            RestResponseProperty = 'entities'
        }

        $databases = Invoke-DynatraceAPIMethod @splatParameters     

        # If Name parameter is used, get individual entity properties to provide
        # more details on the database services
        #
        if ($Name) {
            foreach ($database in $databases){
                $dets = Get-DynatraceEntityProperty -entityID $database.entityID
                $output += [PSCustomObject]@{
                    entityId = $database.entityID
                    Name = $dets.displayName
                    Host = $dets.properties.databaseHostNames -join ','
                    HostPort = $dets.properties.port
                    IPAddress = $dets.properties.ipAddress -join ','
                    Vendor = $dets.properties.databaseVendor
                }
            }
        } else {
            foreach ($database in $databases) {
                $output += [PSCustomObject]@{
                    entityID = $database.entityId
                    Name = $database.displayName
                }
            }
        }
        $output
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



