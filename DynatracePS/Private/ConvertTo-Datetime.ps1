Function ConvertTo-Datetime {
<#
.SYNOPSIS
    Convert a timestamp value from dynatrace (which uses millisecond timestamps) to a datetime

.DESCRIPTION
    Convert a timestamp value from dynatrace (which uses millisecond timestamps) to a datetime

.PARAMETER TimeStamp
    Timestamp value 

.NOTES
    https://community.dynatrace.com/t5/REST-API/Dynatrace-API-Timestamp/td-p/81309

#>
    param(
        [long]$TimeStamp
    )
    begin {
        [DateTime]$Epoch = Get-Date 1970-01-01
    }
    process {
        (($Epoch) + ([System.TimeSpan]::FromMilliseconds($TimeStamp))).ToLocalTime()
    }
}