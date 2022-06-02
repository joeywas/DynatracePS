function Invoke-DynatraceAPIMethod {
<#
.SYNOPSIS
    Invoke a method in the Dynatrace API. This is a service function to be called by other functions.

.DESCRIPTION
    Invoke a method in the Dynatrace API. This is a service function to be called by other functions.

.PARAMETER Uri
    Uri to use for Invoke-RestMethod

.PARAMETER Method
    Defaults to GET

.PARAMETER Headers
    Headers to use. Will be joined with authorization header.

.PARAMETER GetParameter
    Get parameters to include

.PARAMETER RestResponseProperty
    Property of the rest response to return as results.

.PARAMETER LevelOfRecursion
    Internal parameter used to help determine how far into the matrix we are

.EXAMPLE
    Invoke-DynatraceAPIMethod -Uri https://environmentid.live.dynatrace.com/api/v2/entityTypes -RestResponseProperty types

.NOTES
    https://api.dynatrace.com/spec/#/
    
#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Uri]$Uri,
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = 'GET',
        [Hashtable]$Headers,
        [Hashtable]$GetParameter = @{},
        [string]$RestResponseProperty,
        [System.Object]$Body,
        [string]$ContentType,
        [int]$LevelOfRecursion = 1
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] Function started. PSBoundParameters: $($PSBoundParameters | Out-String)"

#region Headers
        $config = Get-DynatracePSConfig
        $access_token = $config.accesstoken

        if (-not $access_token) {
            Write-Warning "[$($MyInvocation.MyCommand.Name) $Level] Must first configure an access token with Set-DynatracePSConfig -AccessToken <token>. Exiting..."
            break
        }

        $_headers = @{
            Authorization = "Api-Token $access_token"
        }
        if ($Headers) {
            $_headers += $Headers
        }
#endregion Headers

        $uriQuery = ConvertTo-ParameterHash -Uri $Uri

        $internalGetParameter = Join-Hashtable $uriQuery, $GetParameter
        [Uri]$LeftPartOfURI = $Uri.GetLeftPart('Path')
        [Uri]$FinalURI = "{0}{1}" -f $LeftPartOfURI,(ConvertTo-GetParameter $internalGetParameter)

        Write-Verbose "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] FinalURI: [$FinalUri]"

        try {
            $splatParameters = @{
                Uri = $FinalURI
                Method = $Method
                Headers = $_headers
                ResponseHeadersVariable = 'ResponseHeaders'
                StatusCodeVariable = 'StatusCode'
            }
            if ($body) {
                Write-Debug "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] body: $($body | Out-String)"
                $splatParameters += @{
                    Body = $body
                }
            }
            if ($ContentType) {
                $splatParameters += @{
                    ContentType = $ContentType
                }
            }

            Write-Debug "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] splatParameters: $($splatParameters | Out-String)"

            $RestResponse = Invoke-RestMethod @splatParameters
            Write-Debug "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] RestResponse: $($RestResponse | Out-String)"
            Write-Debug "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] ResponseHeaders: $($ResponseHeaders | Out-String)"
            Write-Debug "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] StatusCode: $($StatusCode | Out-String)"

        } catch {
            Write-Warning "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] Problem with Invoke-RestMethod $uri"
            $_
            break
        }
        Write-Verbose "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] Executed RestMethod"

        Test-ServerResponse -InputObject $RestResponse -StatusCode $StatusCode
    }

    process {
        if ($RestResponse) {
            Write-Verbose "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] nextPageKey: $($RestResponse.nextPageKey)"

            $NextPageKey = $RestResponse.nextPageKey

            if ($RestResponseProperty) {
                $result = ($RestResponse).$RestResponseProperty
            } else {
                $result = $RestResponse
            }

            if (-not $PSBoundParameters["GetParameter"]) {
                $PSBoundParameters["GetParameter"] = $internalGetParameter
            }

            do {
                
                if (-not $NextPageKey) {
                    # if there is no page key, then quit
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