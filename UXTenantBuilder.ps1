# Setup Information.  The only thing that will really change is the Endpoint for future calls
$serverName = "https://as1506.awmdm.com"
$infoEndpoint = "/API/system/info"
$restAPIKey = "fq4Bi1p7DHsSpjxgeHdvWf41YEkpZ3PCIEbClTwj7mY="
$contentType = "application/json"

# Build the REST Basic Auth Username.
$userName = "curryware\scurry"
$password = "AirWatch1"
$concateUserInfo = $userName + ":" + $password
$encoding = [System.Text.Encoding]::ASCII.GetBytes($concateUserInfo)
$encodedUserName = [Convert]::ToBase64String($encoding)
$encodedUserName = "Basic " + $encodedUserName

# Add everything to the headers before making the call.
$headers = @{"Authorization" = $encodedUserName; "aw-tenant-code" = $restAPIKey; "Accept" = $contentType; "Content-Type" = $contentType}
$endpointURL = $serverName + $infoEndpoint

# Get a list of Smart Groups and print them all out.
$webReturn = Invoke-RestMethod -Method Get -Uri $endpointURL -Headers $headers
Write-Output("Console Version: " + $webReturn.ProductVersion)

# Get the base OG on which we will build the child OG based on the name.
$groupEndpoint = "/API/system/groups/search"
$groupID = "td_scotcurry"
$endpointToCall = $groupEndpoint + "?group_id=" + $groupID
$endpointURL = $serverName + $endpointToCall
$webReturn = Invoke-RestMethod -Method Get -Uri $endpointURL -Headers $headers
Write-Output ($groupID + "= ID: " + $webReturn.LocationGroups[0].Id.Value)
$parentGroupID = $webReturn.LocationGroups[0].Id.Value

