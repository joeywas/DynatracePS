function Test-ServerResponse {
    [CmdletBinding()]
    <#
        .SYNOPSIS
            Evaluate the response of the API call
        .NOTES
            Thanks to Lipkau:
            https://github.com/AtlassianPS/JiraPS/blob/master/JiraPS/Private/Test-ServerResponse.ps1
    #>
    param (
        [Parameter( ValueFromPipeline )]
        [PSObject]$InputObject,
        [string]$StatusCode
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Checking response for error"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Checking response for error"
    }

    process {
        if ($StatusCode -eq 204) {
            Write-Debug "[$($MyInvocation.MyCommand.Name)] Response code 204: Valid payload"
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Response code 204: Valid payload"
        } elseif ($StatusCode -gt 200) {
            Write-Debug "[$($MyInvocation.MyCommand.Name)] Error code found, throwing error"
            throw ("Code {0}: {1}" -f $StatusCode,($InputObject.message -join ','))
        } else {
            Write-Debug "[$($MyInvocation.MyCommand.Name)] Code: $StatusCode"
        }
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Done checking response for error"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Done checking response for error"
    }
}