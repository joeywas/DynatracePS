# Changelog
All notable changes to IvantiPS project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.2] - 2022-04-29
First version to publish to PS gallery
### Added
- Function: Get-IvantiAgency to return agencies
- Function: Get-IvantiEmployee to return employees
- Function: Get-IvantiBusinessObjectMetadata to return all types of meta data about ISM Business Objects
- Function: Get-IvantiBusinessObject to get business objects
- Function: Get-IvantiCI to get configuration items aka assets
### Changed
- Renamed New-IvantiSession to Connect-IvantiTenant to better reflect what it does

## [0.0.2] - 2022-04-26
### Added
- Function: New-IvantiSession to initiate connection to Ivanti
- Function: Get-IvantiSession to return the session id value stored in module's private data
- Function: Set-IvantiPSConfig to store configuration values
- Function: Get-IvantiPSConfig to return stored configuration values
- Private Functions: ConvertTo-GetParameter, ConvertTo-ParameterHash, Invoke-IvantiMethod, Join-Hashtable, Test-ServerResponse, and Write-DebugMessage to support public functions

## [0.0.1] - 2022-04-24
### Added
- This CHANGELOG file
- Good examples and basic guidelines, including proper date formatting.
- Counter-examples: "What makes unicorns cry?" "A bad CHANGELOG!"