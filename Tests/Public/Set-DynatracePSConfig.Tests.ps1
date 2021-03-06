Describe 'Set-DynatracePSConfig' {

    BeforeAll {
        $EnvironmentID = 'testtenant'
        $AccountUuid = 'dynatrace-account-guid'
        $OAuthClientSecret = 'dynatrace-oauth-client-secret'
        $AccessToken = 'dynatrace-access-token'
        $config = "$([Environment]::GetFolderPath('ApplicationData'))\DynatracePS\config.json"
        # If there is an existing config in this session, make a backup to restore it later
        if (Test-Path $config) {
            Write-Verbose "Backing up original config"
            $configBackup = "$config.backup"
            Move-Item $config $configBackup -Force
        } else {
            $configBackup = ''
        }
    }
    
    It "Given valid parameters, creates config.json" {
        $splatParm = @{
            EnvironmentID = $EnvironmentID
            AccountUuid = $AccountUuid
            OAuthClientSecret = $OAuthClientSecret
            AccessToken = $AccessToken
        }
        Set-DynatracePSConfig @splatParm
        $config | Should -Exist
    }

    AfterAll {
        if (Test-Path $configBackup) {
            Write-Verbose "Moving original config back to $config"
            Move-Item $configBackup $config -Force
        }
    }
}