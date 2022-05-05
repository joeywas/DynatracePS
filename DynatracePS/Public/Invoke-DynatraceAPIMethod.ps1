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
            ONLY WORKS WITH THE api/v2/entityTypes for now
        #>

        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [Uri]$Uri,
            [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = 'GET',
            [Hashtable]$Headers,
            [Hashtable]$GetParameter = @{},
            [string]$PropertyForResults = 'types',
            [int]$LevelOfRecursion = 1
        )

        begin {
            Write-Verbose "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] Function started"
            Write-Debug "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] Function started. PSBoundParameters: $($PSBoundParameters | Out-String)"

#region AuthHeaders
            $config = Get-DynatracePSConfig
            $access_token = $config.accesstoken

            if (-not $access_token) {
                Write-Warning "[$($MyInvocation.MyCommand.Name) $Level] Must first configure an access token with Set-DynatracePSConfig -AccessToken <token>. Exiting..."
                break
            }

            $_headers = @{
                Authorization = "Api-Token $access_token"
            }
#endregion AuthHeaders

            $uriQuery = ConvertTo-ParameterHash -Uri $Uri
            $internalGetParameter = Join-Hashtable $uriQuery, $GetParameter

            [Uri]$LeftPartOfURI = $Uri.GetLeftPart('Path')
            [Uri]$FinalURI = "{0}{1}" -f $LeftPartOfURI,(ConvertTo-GetParameter $internalGetParameter)

            Write-Verbose "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] FinalURI: [$FinalUri]"

            try {
                $RestResponse = Invoke-RestMethod -Uri $FinalURI -Method $Method -Headers $_headers
            } catch {
                Write-Warning "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] Problem with Invoke-RestMethod $uri"
                $_
                break
            }
            Write-Verbose "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] Executed RestMethod"

            Test-ServerResponse -InputObject $RestResponse
        }

        process {
            if ($RestResponse) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] nextPageKey: $($RestResponse.nextPageKey)"
                $result = ($RestResponse).$PropertyForResults
                $NextPageKey = $RestResponse.nextPageKey

                do {
                    if (-not $PSBoundParameters["GetParameter"]) {
                        $PSBoundParameters["GetParameter"] = $internalGetParameter
                    }
                    
                    if (-not $NextPageKey) {
                        break
                    } else {
                        # Output results from this loop
                        $result
                    }
                    
                    $PSBoundParameters["GetParameter"]['nextPageKey'] = $NextPageKey
                    $PSBoundParameters["LevelOfRecursion"] = $LevelOfRecursion + 1

                    Write-Verbose "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] Calling Invoke-DynatraceApiMethod"
                    $result = Invoke-DynatraceApiMethod @PSBoundParameters
                } while (-not $NextPageKey)
                $result
            }
        }
        end {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
            Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
        }
    }



