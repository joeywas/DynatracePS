function Get-DynatraceProblem {
<#
    .SYNOPSIS
        Gets problem(s) in Dynatrace environment

    .DESCRIPTION
        Gets problem(s) in Dynatrace environment
    
    .PARAMETER From
        Start of the requested time frame. Defaults to now-2h
        There are several recognized formats available, see:
        https://www.dynatrace.com/support/help/shortlink/api-problems-v2-get-list#parameters

    .PARAMETER To
        End of the requested time frame. Defaults to current timestamp
        There are several recognized formats available, see:
        https://www.dynatrace.com/support/help/shortlink/api-problems-v2-get-list#parameters

    .PARAMETER Status
        Specific status of problem to get. may be open or closed. defaults to both

    .PARAMETER Raw
        Output the raw json result, no formatting of results

    .EXAMPLE
        Get-DynatraceProblem

    .EXAMPLE
        Get-DynatraceProblem -From now-12h

        Get all problems in last 12 hours

    .EXAMPLE
        Get-DynatraceProblem -From now-12h -To now-11h

        Get all problems between 12 and 11 hours ago
        
    .NOTES
        https://www.dynatrace.com/support/help/dynatrace-api/environment-api/problems-v2/
#>

    [CmdletBinding()]
    param(
        #[Parameter(Mandatory,ParameterSetName = 'id')]
        #[string]$Id,
        #[Parameter(Mandatory,ParameterSetName = 'name')]
        #[string]$Name
        [string]$From,
        [string]$To,
        [ValidateSet('open','closed')]
        [string]$Status,
        [switch]$Raw

    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Function started"

        $EnvironmentID = (Get-DynatracePSConfig).EnvironmentID

        $uri = "https://$EnvironmentID.live.dynatrace.com/api/v2/problems"

        $problemSelector = @()
        if ($Status) {
            $problemSelector += "status(`"$($Status)`")"
        }

        $GetParameter = @{}
        if ($from) {
            $GetParameter += @{from = $from}
        }
        if ($to) {
            $GetParameter += @{to = $to}
        }

        # If we had problems selectors, join them together and add to get
        #
        if ($problemSelector) {
            $problemSelectorJoined = $problemSelector -join ','
            $GetParameter += @{
                problemSelector = $problemSelectorJoined
            }
        }

        Write-Verbose "[$($MyInvocation.MyCommand.Name)] $Uri"
    }

    process {
        $splatParameters = @{
            Uri = $uri
            GetParameter = $GetParameter
            RestResponseProperty = 'problems'
        }
        $problems = Invoke-DynatraceAPIMethod @splatParameters

        if ($Raw) {
            $output = $problems
        } else {
            $output = @()
            foreach ($problem in $problems) {
                $StartTime = ConvertTo-DateTime -TimeStamp $problem.StartTime
                if ($problem.EntTime -ne '-1') {
                    $EndTime = ConvertTo-DateTime -TimeStamp $problem.EndTime
                } else {
                    $EndTime = ''
                }
                $ManagementZones = $problem.managementZones.name -join ','
                $AffectedEntities = $problem.AffectedEntities.name -join ','
                $Tags = $problem.entityTags.stringRepresentation -join ','
                $item = [PSCustomObject]@{
                    ProblemID = $problem.displayID
                    Title = $problem.Title
                    Impact = $problem.impactLevel
                    Severity = $problem.severityLevel
                    Status = $problem.status
                    ManagementZones = $ManagementZones
                    AffectedEntities = $AffectedEntities
                    Tags = $tags
                    StartTime = $StartTime
                    EndTime = $EndTime
                }
                $output += $item
            }
        }

        $output
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-Debug "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}



