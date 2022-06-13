#
# Module manifest for module 'DynatracePS'
#
# Generated by: joey.was@gmail.com
#
# Generated on: 5/3/2022
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'DynatracePS.psm1'

    # Version number of this module.
    ModuleVersion = '0.1.13'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID = '5de0ae72-378c-453e-997b-251203a13ef1'

    # Author of this module
    Author = 'joey.was@gmail.com'

    # Company or vendor of this module
    CompanyName = 'joey.was@gmail.com'

    # Copyright statement for this module
    Copyright = '(c) 2022 joey.was@gmail.com'

    # Description of the functionality provided by this module
    Description = 'PowerShell module to interact with Dynatrace SaaS API'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '3.0'

    # Name of the PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # ClrVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Get-DynatracePSConfig',
        'Set-DynatracePSConfig',
        'Connect-DynatraceAccountManagement', 
        'Get-DynatraceUser', 
        'Get-DynatraceUserLastLogin',
        'Get-DynatraceUserGroup', 
        'Get-DynatraceEntityType',
        'Get-DynatraceEnvironment', 
        'Get-DynatraceGroup',
        'Get-DynatraceGroupPermission', 
        'Get-DynatraceGroupUser', 
        'Get-DynatracePermission', 
        'Get-DynatraceManagementZone',
        'Get-DynatraceManagementZoneProperty',
        'Get-DynatraceQuota', 
        'Get-DynatraceEffectivePermission', 
        'Get-DynatraceEntity',
        'Get-DynatraceEntityProperty',
        'Get-DynatraceHost',
        'Get-DynatraceHostProperty',
        'Get-DynatraceHostGroup',
        'Get-DynatraceHostGroupProperty',
        'Get-DynatraceProblem',
        'Get-DynatraceProcessGroup',
        'Get-DynatraceProcessGroupProperty',
        'Get-DynatraceProcess',
        'Get-DynatraceProcessProperty',
        'Get-DynatraceContainer',
        'Get-DynatraceSettingsSchema',
        'Get-DynatraceTag'
        'Get-DynatraceSubscription',
        'New-DynatraceManagementZone',
        'New-DynatraceMzRuleHostGroup',
        'Remove-DynatraceManagementZone',
        'Rename-DynatraceManagementZone',
        'Update-DynatraceManagementZone'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()

    # Variables to export from this module
    # VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. 
    # This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{

        'TokenData' = @{}

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('Dynatrace','api','Linux')

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/joeywas/DynatracePS/blob/main/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/joeywas/DynatracePS'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

            # Prerelease string of this module
            IsPrerelease = 'True'

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

        } # End of PSData hashtable

    } # End of PrivateData hashtable

# HelpInfo URI of this module
HelpInfoURI = 'https://github.com/joeywas/DynatracePS'

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

