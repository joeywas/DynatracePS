function Set-DynatracePSConfig {
<#
.SYNOPSIS
    Set the Dynatrace SaaS Environment ID to use when connecting

.DESCRIPTION
    Set the Dynatrace SaaS Environment ID to use when connecting
    Saves the information to DynatracePS/config.json file in user profile

.PARAMETER EnvironmentID
    Dynatrace SaaS Environment ID. This is the left most part of the hostname name:  envid.live.dynatrace.com

.PARAMETER AccountUuid
    Dynatrace Account ID. You can find the UUID on the Account > Account management API page, during creation of an OAuth client

.PARAMETER OAuthClientSecret
    The client_secret value that is created in the Account management API page. Used for connecting to Dynatrace Account Management API

.PARAMETER AccessToken
    The access token or personal access token for Dynatrace API

.EXAMPLE
    Set-DynatracePSConfig -EnvironmentID 'envid' -AccountUuid 'dynatrace-account-id'

.NOTES
    https://www.dynatrace.com/support/help/dynatrace-api/basics/dynatrace-api-authentication#tabgroup--generate-token--personal-access-token
    https://www.dynatrace.com/support/help/get-started/access-tokens
#>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '',
        Justification='This function is trivial enough that we do not need ShouldProcess')]
    Param (
		[String]$EnvironmentID,
		[String]$AccountUuid,
        [String]$OAuthClientSecret,
        [String]$AccessToken
    )
    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"

        $cliXmlFile = "$([Environment]::GetFolderPath('ApplicationData'))\DynatracePS\OauthSecret.xml"
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Oauth secret will be stored in $($OauthXmlFile)"

        $AccessXmlFile = "$([Environment]::GetFolderPath('ApplicationData'))\DynatracePS\AccessToken.xml"
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Access token will be stored in $($AccessXmlFile)"

        $configPath = "$([Environment]::GetFolderPath('ApplicationData'))\DynatracePS\config.json"
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Configuration will be stored in $($configPath)"

        if (-not (Test-Path $configPath)) {
            # If the config file doesn't exist, create it
            $null = New-Item -Path $configPath -ItemType File -Force
        }
    }

    process {
        $ExistingConfig = Get-DynatracePSConfig

        # If no environment ID passed in, and there is existing value, use existing
        if ((-not $EnvironmentID) -and ($ExistingConfig.EnvironmentID)) {
            $EnvironmentID = $ExistingConfig.EnvironmentID
        }
        if ((-not $AccountUuid) -and ($ExistingConfig.AccountUuid)) {
            $AccountUuid = $ExistingConfig.AccountUuid
        }
        $config = [ordered]@{
            EnvironmentID = $EnvironmentID
            AccountUuid = $AccountUuid
        }
        $config | ConvertTo-Json | Set-Content -Path "$configPath"

        if ($OAuthClientSecret) {
            $username = 'DynatraceAccountManagement'
            $pass = ConvertTo-SecureString $OAuthClientSecret -AsPlainText -Force
            [PSCredential]$credential = New-Object System.Management.Automation.PSCredential(
                $UserName, $pass
            )
            $credential | Export-Clixml $cliXmlFile
        }

        if ($AccessToken) {
            $username = 'DynatraceAccess'
            $pass = ConvertTo-SecureString $AccessToken -AsPlainText -Force
            [PSCredential]$credential = New-Object System.Management.Automation.PSCredential(
                $UserName, $pass
            )
            $credential | Export-Clixml $AccessXmlFile
        }
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
    }
} # end function
