$vIDMInstance = "https://curryware2.vmwareidentity.com"
$acceptType = "application/vnd.vmware.horizon.manager.oauth2client+json"
$contentType = "application/vnd.vmware.horizon.manager.oauth2client+json"

# To set this up you need to create a service access token.  The information about how to do this is at:
# https://github.com/vmware/idm/wiki/Integrating-Client-Credentials-app-with-OAuth2
$clientID = "UXTenantBuilder"
$sharedSecret = "VVK1PhCw9XYiDoVrjaZUZUrZZm9SF5DWTSGqrcx3QZsfI2l0"
$oauthEndpoint = "/SAAS/auth/oauthtoken"
$contentType = "application/x-www-form-urlencoded"

$stringToEncode = $clientID + ":" + $sharedSecret
$encoding = [System.Text.Encoding]::ASCII.GetBytes($stringToEncode)
$encodedUserName = [Convert]::ToBase64String($encoding)
$bearerHeader = "Basic " + $encodedUserName

$headers = @{"Authorization" = $bearerHeader; "Content-Type" = $contentType}
$oauthUri = $vIDMInstance + $oauthEndpoint + "?grant_type=client_credentials"
$webReturn = Invoke-RestMethod -Method Post -Uri $oauthUri -Headers $headers
$accessToken = $webReturn.access_token

$userEndpoint = "/SAAS/jersey/manager/api/scim/Users"
$userAuthToken = "HZN " + $accessToken
$applicationJSON = "application/json"
$headers = @{"Authorization" = $userAuthToken; "Content-Type" = $applicationJSON; "Accept" = $applicationJSON}
$userUri = $vIDMInstance + $userEndpoint
$webReturn = Invoke-RestMethod -Method Get -Uri $userUri -Headers $headers
Write-Output $webReturn
