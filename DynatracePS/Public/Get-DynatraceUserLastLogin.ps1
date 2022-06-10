function Get-DynatraceUserLastLogin {
<#
    .SYNOPSIS
        List the users with last login time

    .DESCRIPTION
        List the users with last login time
        
    .EXAMPLE
        Get-DynatraceUserLastLogin

    .NOTES
        https://api.dynatrace.com/spec/#/User%20management/UsersController_getUsers

#>

    [CmdletBinding()]
    param()

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process {
        Get-DynatraceUser | Select-Object email, 
            @{
                n='lastSuccessfulLoginUTC';
                e={
                    ($_.userLoginMetadata).lastSuccessfulLogin
                }
            }, @{
                n='lastSuccessfulLoginLocal';
                e={
                    $ParsedDateTime = Get-Date ($_.userLoginMetadata).lastSuccessfulLogin;
                    $ParsedDateTime.ToLocalTime()
                }
            }, @{
                n='successfulLoginCounter';
                e={
                    ($_.userLoginMetaData).successfulLoginCounter
                }
            }
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



