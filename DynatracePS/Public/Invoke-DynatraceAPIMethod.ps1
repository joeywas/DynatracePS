function Invoke-DynatraceAPIMethod {
    <#
        .SYNOPSIS
            Invoke a method on in the Dynatrace API. This is a service function to be called by other functions.

        .DESCRIPTION
            Invoke a method on in the Dynatrace API. This is a service function to be called by other functions.

        .PARAMETER RestPath
            The rest path to append to the base url

        .EXAMPLE
            Invoke-DynatraceAPIMethod -RestPath '/eventTypes'

        .NOTES
            https://api.dynatrace.com/spec/#/

        #>

        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [String]$RestPath,
            [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = 'GET'
        )

        begin {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
            Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

            $config = Get-DynatracePSConfig
            $access_token = $config.accesstoken
            $headers = @{
                Authorization = "Api-Token $access_token"
            }

            $Uri = "https://$($config.EnvironmentID).live.dynatrace.com/api/v2$RestPath"
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
        }

        process {
            try {
                Invoke-RestMethod -Uri $Uri -Method $Method -Headers $headers
            } catch {
                Write-Warning "[$($MyInvocation.MyCommand.Name)] Problem with Invoke-RestMethod $uri"
                $_
                break
            }
        }
        end {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
            Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
        }
    }



