function ConvertTo-GetParameter {
    <#
    .SYNOPSIS
    Generate the GET parameter string for an URL from a hashtable
    #>
    [CmdletBinding()]
    param (
        [Parameter( Position = 0, Mandatory = $true, ValueFromPipeline = $true )]
        [hashtable]$InputObject
    )

    process {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Making HTTP get parameter string out of a hashtable"
        Write-Verbose ($InputObject | Out-String)
        [string]$parameters = "?"
        # If the key is name nextPageKey is in the input object, it is *the only*
        # key that should be included in the parameters
        #
        if ('nextPageKey' -in $InputObject.Keys) {
            $value = $InputObject['nextPageKey']
            $parameters += "nextPageKey=$($value)&"
        } else {
            foreach ($key in $InputObject.Keys) {
                $value = $InputObject[$key]
                $parameters += "$key=$($value)&"
            }
        }
        $parameters -replace ".$"
    }
}
