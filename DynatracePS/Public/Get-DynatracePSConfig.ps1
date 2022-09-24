function Get-DynatracePSConfig {
<#
.SYNOPSIS
    Get default configurations for DynatracePS from config.json file

.DESCRIPTION
    Get default configurations for DynatracePS from config.json file

.EXAMPLE
    Get-DynatracePSConfig
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param ()

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"
        $config = "$([Environment]::GetFolderPath('ApplicationData'))\DynatracePS\config.json"
        $OauthXmlFile = "$([Environment]::GetFolderPath('ApplicationData'))\DynatracePS\OauthSecret.xml"
        $AccessXmlFile = "$([Environment]::GetFolderPath('ApplicationData'))\DynatracePS\AccessToken.xml"
    }

    process {
        $Output = [PSCustomObject]@()
        if (Test-Path $config) {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Getting config from [$config]"
            if (Test-Path $OauthXmlFile) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Getting Oauth Secret from [$OauthXmlFile]"
                $OauthCredential = [PSCredential](Import-Clixml $OauthXmlFile)
                $OauthClientSecret = $OauthCredential.GetNetworkCredential().Password
            } else {
                $OauthClientSecret = ''
            }
            if (Test-Path $AccessXmlFile) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Getting Access Token from [$AccessXmlFile]"
                $AccessCredential = [PSCredential](Import-Clixml $AccessXmlFile)
                $AccessToken = $AccessCredential.GetNetworkCredential().Password
            } else {
                $AccessToken = ''
            }
            $Output = (Get-Content -Path "$config" -ErrorAction Stop | ConvertFrom-Json)
            $Output | Add-Member -MemberType NoteProperty -Name OauthClientSecret -Value $OauthClientSecret
            $Output | Add-Member -MemberType NoteProperty -Name AccessToken -Value $AccessToken
        } else {
            Write-Warning "[$($MyInvocation.MyCommand.Name)] No config found at [$config]"
            Write-Warning "[$($MyInvocation.MyCommand.Name)] Use Set-DynatracePSConfig first!"
            return
        }
        $Output
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function complete"
    }
} # end function

