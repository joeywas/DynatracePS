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
            return
        }
        if (-not $OauthClientSecret) {
            Write-Warning "[$($MyInvocation.MyCommand.Name)] OauthClientSecret is required. Please use Set-DynatracePSConfig first. Exiting..."
            return
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

        $TokenData = $MyInvocation.MyCommand.Module.PrivateData.TokenData
    }

    process {
        Write-Debug "[$($MyInvocation.MyCommand.Name)] TokenData: $($TokenData | Out-String)"
        
        $Now = Get-Date

        if (($Now -lt $TokenData.token_expires) -and (-not $GetNewtoken)) {
            Write-Debug "[$($MyInvocation.MyCommand.Name)] Existing token should still be good, using it"
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Existing token should still be good, using it"
        } else {
            Write-Debug "[$($MyInvocation.MyCommand.Name)] Getting new token"
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Getting new token"
            try {
                $splatParameter = @{
                    Uri = $GetTokenURL 
                    Method = 'POST' 
                    Body = $body 
                    ContentType = $ContentType
                }
                $GetTokenReturn = (Invoke-WebRequest @splatParameter).Content | ConvertFrom-Json

                Write-Debug "[$($MyInvocation.MyCommand.Name)] Adding results to module PrivateData"
                
                $TokenData = @{
                    'scope' = $GetTokenReturn.scope
                    'token_type' = $GetTokenReturn.token_type
                    'expires_in' = $GetTokenReturn.expires_in
                    'access_token' = $GetTokenReturn.access_token
                    'resource' = $GetTokenReturn.resource
                    'token_expires' = (Get-Date).AddSeconds($GetTokenReturn.expires_in)
                }
                $MyInvocation.MyCommand.Module.PrivateData.TokenData = $TokenData
            } catch {
                Write-Warning "[$($MyInvocation.MyCommand.Name)] Problem getting $GetTokenURL"
                $_
                return
            }
        }

        # return everything to the pipeline
        $TokenData
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}


