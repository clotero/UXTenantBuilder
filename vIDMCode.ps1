# Force TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$vIDMInstance = "https://clotero.vidmpreview.com"
$acceptType = "application/vnd.vmware.horizon.manager.oauth2client+json"
$contentType = "application/vnd.vmware.horizon.manager.oauth2client+json"

$localDirectoryName = "API_Directory"
$localDomainName = "local_domain"

# To set this up you need to create a service access token.  The information about how to do this is at:
# https://github.com/vmware/idm/wiki/Integrating-Client-Credentials-app-with-OAuth2
$clientID = "CloteroPostMan"
$sharedSecret = "ky7E4EnY5QVEtNLU05PY1vrevlUKwgRgOsW1Tdng1Vo9C9xw"
$oauthEndpoint = "/SAAS/auth/oauthtoken"
$contentType = "application/x-www-form-urlencoded"

#Encode Client + Secre into Authorization header.
$stringToEncode = $clientID + ":" + $sharedSecret
$encoding = [System.Text.Encoding]::ASCII.GetBytes($stringToEncode)
$encodedUserName = [Convert]::ToBase64String($encoding)
$bearerHeader = "Basic " + $encodedUserName

$headers = @{"Authorization" = $bearerHeader; "Content-Type" = $contentType}
$headersssss = @{"Authorization" = $bearerHeader}
$oauthUri = $vIDMInstance + $oauthEndpoint + "?grant_type=client_credentials"
$webReturn = Invoke-RestMethod -Method Post -Uri $oauthUri -Headers $headers
$accessToken = $webReturn.access_token

$userEndpoint = "/SAAS/jersey/manager/api/scim/Users"
$userAuthToken = "HZN " + $accessToken
$applicationJSON = "application/json"
$headers = @{"Authorization" = $userAuthToken; "Content-Type" = $applicationJSON; "Accept" = $applicationJSON}
$userUri = $vIDMInstance + $userEndpoint
$webReturn = Invoke-RestMethod -Method Get -Uri $userUri -Headers $headers

#Create local directory
$directoryBody = @{
    type='LOCAL_DIRECTORY'
    domains=$localDomainName
    name=$localDirectoryName
    }
$jsonBody = $directoryBody | ConvertTo-Json
Write-Output $jsonBody
$directoryEndpoint = "/SAAS/jersey/manager/api/connectormanagement/directoryconfigs"
$directoryURI = $vIDMInstance + $directoryEndpoint
$vmwareHorizonConnector = "application/vnd.vmware.horizon.manager.connector.management.directory.local+json"
$headers = @{"Authorization" = $userAuthToken; "Content-Type" = $vmwareHorizonConnector}
$webReturn = Invoke-RestMethod -Method Post -Uri $directoryUri -Headers $headers -Body $jsonBody 

#Create local users


Write-Output $webReturn
