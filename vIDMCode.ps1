$vIDMInstance = "https://curryware2.vmwareidentity.com"
$acceptType = "application/vnd.vmware.horizon.manager.oauth2client+json"
$contentType = "application/vnd.vmware.horizon.manager.oauth2client+json"

$clientID = "UXTenantBuilder"
$sharedSecret = "VVK1PhCw9XYiDoVrjaZUZUrZZm9SF5DWTSGqrcx3QZsfI2l0"
$oauthEndpoint = "/SAAS/auth/oauthtoken"
$contentType = "application/x-www-form-urlencoded"

$stringToEncode = $clientID + ":" + $sharedSecret
Write-Output $stringToEncode
$encoding = [System.Text.Encoding]::ASCII.GetBytes($stringToEncode)
$encodedUserName = [Convert]::ToBase64String($encoding)
Write-Output $encodedUserName
$bearerHeader = "Basic " + $encodedUserName

$headers = @{"Authorization" = $bearerHeader; "Content-Type" = $contentType}
$oauthUri = $vIDMInstance + $oauthEndpoint + "?grant_type=client_credentials"
$webReturn = Invoke-RestMethod -Method Post -Uri $oauthUri -Headers $headers
Write-Output $webReturn