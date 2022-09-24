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
            return
        }

        $_headers = @{
            Authorization = "Api-Token $access_token"
        }
        if ($Headers) {
            $_headers += $Headers
        }
#endregion Headers

        # Create a hash table from the query in the URI, makes it easier to 
        # manage in powershell
        #
        $uriQuery = ConvertTo-ParameterHash -Uri $Uri

        # Generate the Get parameter hashtable that we will use
        #
        $internalGetParameter = Join-Hashtable $uriQuery, $GetParameter
        [Uri]$LeftPartOfURI = $Uri.GetLeftPart('Path')

        # Concat the url and query together to form the URI address we are going to use
        #
        [Uri]$FinalURI = "{0}{1}" -f $LeftPartOfURI,(ConvertTo-GetParameter $internalGetParameter)

        Write-Verbose "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] FinalURI: [$FinalUri]"

        try {
            $splatParameters = @{
                Uri = $FinalURI
                Method = $Method
                Headers = $_headers
            }
            # If -body parm is used, we add it to the splat parameters
            #
            if ($body) {
                Write-Debug "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] body: $($body | Out-String)"
                $splatParameters += @{
                    Body = $body
                }
            }
            # if contenttype is defined, add it to the parameters
            #
            if ($ContentType) {
                $splatParameters += @{
                    ContentType = $ContentType
                }
            }

            Write-Debug "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] splatParameters: $($splatParameters | Out-String)"

            # Invoke-WebRequest (IWR) to Dynatrace. We use IWR instead of Invoke-RestMethod (IRM) because of reasons:
            # 1) IWR is standard from PS version 3 and up. IRM is not
            # 2) IRM doesn't do good job of returning headers and status codes consistently. IWR does.
            #
            # https://www.truesec.com/hub/blog/invoke-webrequest-or-invoke-restmethod
            #
            $Response = Invoke-WebRequest @splatParameters
            $RestResponse = $Response.Content | ConvertFrom-JSON
            $ResponseHeaders = $Response.Headers
            $StatusCode = $Response.StatusCode

            Write-Debug "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] RestResponse: $($RestResponse | Out-String)"
            Write-Debug "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] ResponseHeaders: $($ResponseHeaders | Out-String)"
            Write-Debug "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] StatusCode: $($StatusCode | Out-String)"

        } catch {
            Write-Warning "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] Problem with Invoke-RestMethod $uri"
            $_
            return
        }
        Write-Verbose "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] Executed RestMethod"

        # If there are bad status codes, this will break and cause function to exit
        #
        Test-ServerResponse -InputObject $RestResponse -StatusCode $StatusCode
    }

    process {
        if ($RestResponse) {
            Write-Verbose "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] nextPageKey: $($RestResponse.nextPageKey)"

            # Set next page key to get
            #
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
                    # if there is no page key, then quit, as there are no more pages
                    #
                    break
                } else {
                    # Output results from this loop, and continue on the recursion
                    #
                    $result
                }
                
                $PSBoundParameters["GetParameter"]['nextPageKey'] = $NextPageKey
                $PSBoundParameters["LevelOfRecursion"] = $LevelOfRecursion + 1

                Write-Verbose "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] Calling Invoke-DynatraceApiMethod"

                # Call this same function again (recursion)
                #
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