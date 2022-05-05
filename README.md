# DynatracePS
PowerShell module to interact with the Dynatrace APIs

## Getting Started

Install the DynatracePS module from PSGallery for the current user
```powershell
Install-Module DyntracePS -Scope CurrentUser
```

### Values to Get from Dynatrace

For environment related functions, you will need your Dynatrace environment ID and an access token or personal access token. The environment may be found under Environment Management settings after logging in to the [Dynatrace account page](https://account.dynatrace.com/my/).

For Account Management related functions, you will need your Dynatrace Account Uuid and an account API Oauth client. Information on getting started with Account Management and account API Oauth client is available by logging into your Dynatrace account here: https://account.dynatrace.com/my/ and navigating to Account Management API.

### Set the configuration values
```powershell
Set-DynatracePSConfig -EnvironmentID 'environmentid' `
    -AccountUuid 'accountuuid' `
    -OAuthClientSecret 'oauthclientsecret' `
    -AccessToken 'accesstoken
```

