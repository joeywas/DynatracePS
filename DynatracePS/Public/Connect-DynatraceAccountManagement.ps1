function Connect-DynatraceAccountManagement {
<#
    .SYNOPSIS
        Connect to the Dynatrace Account Management API for SaaS. internal use

    .DESCRIPTION
        Connect to the Dynatrace Account Management API for SaaS. internal use

    .PARAMETER OauthClientSecret
        Client secret generated from the Manage account API OAuth Clients page

    .PARAMETER AccountUuid
        Account UUID from Dynatrace

    .PARAMETER GetNewToken
        Force getting a fresh token

    .EXAMPLE
        Connect-DynatraceAccountManagement

    .NOTES
        https://account.dynatrace.com/my/enterprise-api?
    #>

    [CmdletBinding()]
    param(
        [String]$OauthClientSecret,
        [String]$AccountUuid,
        [Switch]$GetNewtoken
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $config = Get-DynatracePSConfig
        $AccountUuid = $config.AccountUuid
        $OauthClientSecret = $config.OauthClientSecret

        if (-not $AccountUuid) {
            Write-Warning "[$($MyInvocation.MyCommand.Name)] AccountUuid is required. Please use Set-DynatracePSConfig first. Exiting..."
            break
        }
        if (-not $OauthClientSecret) {
            Write-Warning "[$($MyInvocation.MyCommand.Name)] OauthClientSecret is required. Please use Set-DynatracePSConfig first. Exiting..."
            break
        }

        $GetTokenURL = 'https://sso.dynatrace.com/sso/oauth2/token'
        $client_id = (($OauthClientSecret -split '\.') | Select-Object -First 2) -join '.'
        $scope = 'account-idm-read account-idm-write'
        $resource = "urn:dtaccount:$AccountUuid"
        $Body = @{
            grant_type = 'client_credentials'
            client_id = $client_id
            client_secret = $OauthClientSecret
            scope = $scope
            resource = $resource
        }
        $ContentType = 'application/x-www-form-urlencoded'
    }

    process {

        $ExistingTokenExpiration = $MyInvocation.MyCommand.Module.PrivateData.token_expires
        $Now = Get-Date
        if (($Now -lt $ExistingTokenExpiration) -and (-not $GetNewtoken)) {
            Write-Debug "[$($MyInvocation.MyCommand.Name)] Existing token should still be good, using it"
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Existing token should still be good, using it"
            $GetTokenReturn = $MyInvocation.MyCommand.Module.PrivateData |
                Select-Object scope,token_type,expires_in,access_token,resource
            Write-Debug "[$($MyInvocation.MyCommand.Name)] Expires_in: $($GetTokenReturn.expires_in)"
        } else {
            Write-Debug "[$($MyInvocation.MyCommand.Name)] Getting new token"
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Getting new token"
            try {
                $GetTokenReturn = Invoke-RestMethod -Uri $GetTokenURL -Method POST -Body $body -ContentType $ContentType
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Adding results to module PrivateData"
                Write-Debug "[$($MyInvocation.MyCommand.Name)] Adding results to module PrivateData"
                $MyInvocation.MyCommand.Module.PrivateData = @{
                    'scope' = $GetTokenReturn.scope
                    'token_type' = $GetTokenReturn.token_type
                    'expires_in' = $GetTokenReturn.expires_in
                    'access_token' = $GetTokenReturn.access_token
                    'resource' = $GetTokenReturn.resource
                    'token_expires' = (Get-Date).AddSeconds($GetTokenReturn.expires_in)
                }
                Write-Debug "[$($MyInvocation.MyCommand.Name)] Expires_in: $($GetTokenReturn.expires_in)"
            } catch {
                Write-Warning "[$($MyInvocation.MyCommand.Name)] Problem with invoke-restmethod $GetTokenURL"
                $_
                break
            }
        }

        # return everything to the pipeline
        $GetTokenReturn
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}


