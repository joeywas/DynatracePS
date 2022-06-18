function ConvertTo-ParameterHash {
<#
.SYNOPSIS
    Given a URI or uri query, return the query portion as a hash table. For internal use

.DESCRIPTION
    Extract query portion from a URI and return it as a hash table. For internal use

.PARAMETER Uri
    Uri to extract query from and convert to hash

.PARAMETER Query
    Query to convert to hash
#>
    [CmdletBinding( DefaultParameterSetName = 'ByString' )]
    param (
        # URI from which to use the query
        [Parameter( Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'ByUri' )]
        [Uri]$Uri,

        # Query string
        [Parameter( Position = 0, Mandatory, ParameterSetName = 'ByString' )]
        [String]$Query
    )

    process {
        $GetParameter = @{}

        if ($Uri) {
            $Query = $Uri.Query
        }

        if ($Query -match "^\?.+") {
            $Query.TrimStart("?").Split("&") | ForEach-Object {
                $key, $value = $_.Split("=")
                $GetParameter.Add($key, $value)
            }
        }

        Write-Output $GetParameter
    }
}
