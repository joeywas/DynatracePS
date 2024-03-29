# Changelog
All notable changes to DynatracePS will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.22] - 2022-11-29
### Added
-Get-DynatraceMetric to get list of metrics

## [0.1.21] - 2022-09-29
### Added
-Get-DynatraceSettingsObject to return one or more setting objects

## [0.1.20] - 2022-09-23
### Modified
-Function Get-DynatraceSettingsSchema to accept schema id and output as JSON
### Fixed
-All functions, replaced `break` with `return` where appropriate

## [0.1.19] - 2022-08-24
### Added
-Function Get-DynatraceAuditLog

## [0.1.18] - 2022-06-30
### Added
-Function Get-DynatraceDatabase to return database services in Dynatrace
### Modified
-Function Get-DynatraceEntityType to accept -Type parameter, which will return available properties for that Entity Type

## [0.1.17] - 2022-06-28
### Added
-Function Get-DynatraceAlertingProfile to get one or more alerting profiles
-Function Get-DynatraceNotification to get a list of notifications, or details on a single notification

## [0.1.16] - 2022-06-27
### Added
-Function Get-DynatraceHTTPCheckStatus to get status of http checks
-Function Get-DynatraceSyntheticLocation to get list of locations available for synthetic checks

## [0.1.15] - 2022-06-17
### Added
-Function Get-DynatraceHTTPCheck to get all the http checks in dynatrace
-Function Get-DynatraceHTTPCheckProperty to get properties for an http check

## [0.1.14] - 2022-06-10
### Added
-Function Get-DynatraceManagementZoneRule to get all the rules associated with a management zone
-Function Get-DynatraceHostsInHostGroup to return a list of hosts and related host groups

## [0.1.13] - 2022-06-10
### Added
-Get-DynatraceProblem to get problems
-Internal function ConvertTo-Datetime to convert millisecond timestamps used in dynatrace to human readable local time

## [0.1.12]
### Added
-Function Get-DyntraceUserLastLogin to get user name and last login time
### Modified
-Function Get-DynatraceGroupPermission to output MZ name instead of MZ id so it's easier to grok

## [0.1.11]
### Modified
-Replaced Invoke-RestMethod with Invoke-WebRequest in order to provide better support across various PS versions 
### Fixed
-Function Connect-DynatraceAccountManagement now handles caching of token correctly

## [0.1.9] - [0.1.10] - 2022-06-02
Skip ahead / versioning issue

## [0.1.8] - 2022-06-02
### Modified
-Added OutputNotNested parm to function Get-DynatraceGroupPermission for outputing to Excel or FT

## [0.1.7] - 2022-06-01
### Added
-Function New-DynatraceManagementZone to create a management zone
-Function Update-DynatraceManagementZone to update a management zone
-Function Remove-DynatraceManagementZone to remove a management zone
-Function New-DynatraceMzRuleHostGroup to generate a management zone rule object for host group mapping
### Modified
-Function Test-ServerResponse accepts a status code parm and checks that 
-Function Invoke-DynatraceAPIMethod now uses output variables for response headers and status code. also mohr debugging.

## [0.1.6] - 2022-05-09
### Added
-Function Rename-DynatraceManagementZone to rename management zones

## [0.1.5] - 2022-05-07
### Added
-Function Get-DynatraceProcessGroupProperty to return properties for a process group
-Function Get-DynatraceProcessProperty to return properties for a process
### Modified
-Function Get-DynatraceHost cleaned up
-Function Get-DynatraceProcessGroup calls correct function now
-Function Get-DynatraceProcessGroupInstance renamed to Get-DynatraceProcess to better reflect what it does
-All functions that should OutputAsJson now do.
### Fixed
-Function Get-DynatraceHostGroup works with -Name parm now
-Function Get-DynatraceHostProperty works with -Name parm now

## [0.1.4] - 2022-05-06
### Added
-Function Get-DynatraceManagementZoneProperty to get properties for a management zone
-Function Get-DynatraceHostProperty to get properties for a host
-Function Get-DynatraceHostGroupProperty to get properties for a host group
### Modified
-Function Get-DynatraceEntityProperty to optionally output in JSON

## [0.1.2] - 2022-05-05
Initial load!

## [0.0.1] - 2022-05-03
### Added
- This CHANGELOG file
- Good examples and basic guidelines, including proper date formatting.
- Counter-examples: "What makes unicorns cry?" "A bad CHANGELOG!"