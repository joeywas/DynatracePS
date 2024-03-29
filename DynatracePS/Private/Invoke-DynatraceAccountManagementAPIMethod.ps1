function Invoke-DynatraceAccountManagementAPIMethod {
    <#
        .SYNOPSIS
            Invoke a method on in the Dynatrace Account Management API

        .DESCRIPTION
            Invoke a method on in the Dynatrace Account Management API

        .PARAMETER RestPath
            The rest path to append to base url

        .EXAMPLE
            Invoke-DynatraceAccountManagementAPIMethod -RestPath '/ref/v1/account/permissions'

        .NOTES
            https://api.dynatrace.com/spec/#/

        #>

        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [String]$RestPath,
            [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = 'GET',
            [switch]$OutputAsJson
        )

        begin {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
            Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

            $Connection = Connect-DynatraceAccountManagement
            $access_token = $Connection.access_token
            $headers = @{
                Authorization = "Bearer $access_token"
            }
            $Uri = "https://api.dynatrace.com$RestPath"
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
        }

        process {
            try {
                $splatParameters = @{
                    Uri = $Uri 
                    Method = $Method 
                    Headers = $headers
                }
                $Return = Invoke-WebRequest @splatParameters
                $output = $Return.Content | ConvertFrom-JSON
            } catch {
                Write-Warning "[$($MyInvocation.MyCommand.Name)] Problem with Invoke-WebRequest $uri"
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



