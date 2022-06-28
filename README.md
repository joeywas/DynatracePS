# DynatracePS
PowerShell module to interact with Dynatrace SaaS APIs

[![Dev Branch](https://github.com/joeywas/DynatracePS/actions/workflows/pipeline.yml/badge.svg?branch=dev)](https://github.com/joeywas/DynatracePS/actions/workflows/pipeline.yml)

[![Publish To Gallery](https://github.com/joeywas/DynatracePS/actions/workflows/publish-to-gallery.yml/badge.svg)](https://github.com/joeywas/DynatracePS/actions/workflows/publish-to-gallery.yml)

## Getting Started

Install the DynatracePS module from PSGallery for the current user
```powershell
Install-Module DynatracePS -Scope CurrentUser
```

### Values to Get from Dynatrace

For environment related functions, you need a Dynatrace environment ID and an access token or personal access token. The environment ID may be found under Environment Management settings after logging in to the [Dynatrace account page](https://account.dynatrace.com/my/).

For Account Management related functions, you will need your Dynatrace Account Uuid and an account API Oauth client. Information on getting started with Account Management and account API Oauth client is available after logging into your [Dynatrace account page](https://account.dynatrace.com/my/) and navigating to Account Management API.

### Set the configuration values
Once you have the values from Dynatrace, use the `Set-DynatracePSConfig` function to persist values in the user profile. The EnvironmentID and AccountUuid are stored in a json file. the OAuthClientSecret and AccessToken are saved as PSCredential objects with [Export-CliXml](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/export-clixml?view=powershell-7.2).

In order to use the environment functions, the -EnvironmentID and -AccessToken parameters are required to be set.
```powershell
Set-DynatracePSConfig -EnvironmentID 'environmentid' `
    -AccessToken 'accesstoken'
```

In order to use all functions, then you set all four configuration values
```powershell
Set-DynatracePSConfig -EnvironmentID 'environmentid' `
    -AccountUuid 'accountuuid' `
    -OAuthClientSecret 'oauthclientsecret' `
    -AccessToken 'accesstoken'
```

## Why not try getting a user list? (account level function)
```
Get-DynatraceUser
```
## Get a list of the host groups (environment level function)
```
Get-DynatraceHostGroup
```
## ..or a list of Management Zones (environment level function)
```
Get-DynatraceManagementZone
```

## Environment Functions

These functions require an environmentID and AccessToken be configured with `Set-DynatracePSConfig`

- Get-DynatraceContainer
- Get-DynatraceEntity
- Get-DynatraceEntityProperty
- Get-DynatraceEntityType
- Get-DynatraceHost
- Get-DynatraceHostGroup
- Get-DynatraceHostGroupProperty
- Get-DynatraceHostProperty
- Get-DynatraceHostInHostGroup
- Get-DynatraceHTTPCheck
- Get-DynatraceHTTPCheckProperty
- Get-DynatraceHTTPCheckStatus
- Get-DynatraceManagementZone
- Get-DynatraceManagementZoneProperty
- Get-DynatraceManagementZoneRule
- Get-DynatraceProcess
- Get-DynatraceProcessGroup
- Get-DynatraceProcessGroupProperty
- Get-DynatraceProcessProperty
- Get-DynatraceSettingsSchema
- Get-DynatraceSyntheticLocation
- Get-DynatraceTag
- New-DynatraceManagementZone
- Remove-DynatraceManagementZone
- Rename-DynatraceManagementZone
- Update-DynatraceManagementZone

## Account Management Functions

These functions require an accountUuid and OAuthClientSecret be configured with `Set-DynatracePSConfig`

- Get-DynatraceUser
- Get-DynatraceUserLastLogin
- Get-DynatraceUserGroup
- Get-DynatraceGroup
- Get-DynatraceGroupUser
- Get-DynatraceGroupPermission
- Get-DynatraceEnvironment
- Get-DynatracePermission
- Get-DynatraceQuota
- Get-DynatraceEffectivePermission
- Get-DynatraceSubscription
