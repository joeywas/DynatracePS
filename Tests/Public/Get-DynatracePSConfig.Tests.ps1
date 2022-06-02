Describe 'Get-DynatracePSConfig' {

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
        Set-DynatracePSConfig -EnvironmentID $EnvironmentID -AccountUuid $AccountUuid
        $config | Should -Exist
    }

    It "Given config parameters set previously, Get-DynatracePSConfig will return the values" {
        
    }

    AfterAll {       
        if (Test-Path $configBackup) {
            Write-Verbose "Moving original config back to $config"
            Move-Item $configBackup $config -Force
        }
    }
}