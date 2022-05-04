# This file is for testing and development, and is not included in debug or release builds
#
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
foreach($import in @($Public+$Private)) {
    try {
        . $import.fullname
    } catch {
        Write-Error ("{0}: {1}" -f $_.BaseName,$_.Exception.Message)
        exit 1
    }
} # end foreach import in public

# Export the public functions
Export-ModuleMember -Function $($Public | Select-Object -ExpandProperty BaseName)
