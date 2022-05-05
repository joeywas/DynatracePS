Describe 'Set-DynatracePSConfig' {

    BeforeAll {
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
        Set-DynatracePSConfig -EnvironmentID 'testing.live.dynatrace.com' -AccountUuid 'dynatrace-account-guid'
        $config | Should -Exist
    }

    AfterAll {       
        if (Test-Path $configBackup) {
            Write-Verbose "Moving original config back to $config"
            Move-Item $configBackup $config -Force
        }
    }
}