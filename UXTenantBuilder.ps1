# Setup Information.  The only thing that will really change is the Endpoint for future calls
$serverName = "https://as1506.awmdm.com"
$infoEndpoint = "/API/system/info"
$restAPIKey = "fq4Bi1p7DHsSpjxgeHdvWf41YEkpZ3PCIEbClTwj7mY="
$contentType = "application/json"
$userName = "curryware\scurry"
$password = "AirWatch1"

# Build the REST Basic Auth Username.
$concateUserInfo = $userName + ":" + $password
$encoding = [System.Text.Encoding]::ASCII.GetBytes($concateUserInfo)
$encodedUserName = [Convert]::ToBase64String($encoding)
$encodedUserName = "Basic " + $encodedUserName

# Add everything to the headers before making the call.
$headers = @{"Authorization" = $encodedUserName; "aw-tenant-code" = $restAPIKey; "Accept" = $contentType; "Content-Type" = $contentType}
$endpointURL = $serverName + $infoEndpoint

# Get a list of Smart Groups and print them all out.
$webReturn = Invoke-RestMethod -Method Get -Uri $endpointURL -Headers $headers

# Get the base OG on which we will build the child OG based on the name.
$groupEndpoint = "/API/system/groups/search"
$groupID = "td_scotcurry"
$endpointToCall = $groupEndpoint + "?groupid=" + $groupID
$endpointURL = $serverName + $endpointToCall
$webReturn = Invoke-RestMethod -Method Get -Uri $endpointURL -Headers $headers
$parentGroupID = $webReturn.LocationGroups[0].Id.Value

# Create child OG
$tenantName = "Medtronic - UX"
$localeString = "English (United States) [English (United States)]"
$ogJSONString = @{Name=$tenantName;GroupID="uxMedtronic";LocationGroupType="Container";Country="United States";AddDefaultLocation="true";EnableRestApiAccess="true";Timezone=2}
$ogJSON = $ogJSONString | ConvertTo-JSON -Compress
$createGroupString = "/API/system/groups/" + $parentGroupID
$createGroupEndpoint = $serverName + $createGroupString
$webReturn = Invoke-RestMethod -Method Post -Uri $createGroupEndpoint -Headers $headers -Body $ogJSON
$createdOG = $webReturn.Value

# Need to have a role to add to the Admin user.  Hard coding the Console Admin Role for now.
$roleObject = [PSCustomObject]@{
    Id = 78
    Uuid = "73ad9b73-2f0a-4019-93df-8fbca3b7639f"
    Name = "Console Administrator"
    OrganizationGroupUuid = "725aaf25-085f-4e9f-ae60-4d58187e70da"
    LocationGroup = "VMware scotcurry"
    LocationGroupId = "10154"
}

# Define admin object to build out admin record
$adminObject = [PSCustomObject]@{
    userName = "MedtronicAdmin"
    Password = "AirWatch1"
    FirstName = "Medtronic"
    LastName = "Admin"
    Email = "noereply@vmware.com"
    Roles = @($roleObject)
}
$adminJSON = ConvertTo-Json -InputObject $adminObject -Compress

$addAdminEndpoint = "/API/system/admins/addadminuser"
$addAdminUri = $serverName + $addAdminEndpoint
$headers = @{"Authorization" = $encodedUserName; "aw-tenant-code" = $restAPIKey; "Accept" = $contentType; "Content-Type" = $contentType}
$webReturn = Invoke-RestMethod -Method Post -Uri $addAdminUri -Headers $headers -Body $adminJSON

# Add in two users
$userObject = [PSCustomObject]@{
    UserName = "MedtronicUser1"
    Password = "AirWatch1"
    FirstName = "Medtronic"
    LastName = "User1"
    SecurityType = 2
    Email = "noreply@medtronic.com"
}
$userJSON = ConvertTo-Json -InputObject $userObject -Compress

$addUserEndpoint = "/API/system/users/adduser"
$addUserUri = $serverName + $addUserEndpoint
$webReturn = Invoke-RestMethod -Method Post -Uri $addUserUri -Headers $headers -Body $userJSON

# For some reason, you need to activate the user after creation.  Just hard-coding this call for now.
$idToActivate = $webReturn.Value
$activateEndpoint = "/API/system/users/activate"
$activateURI = $serverName + $activateEndpoint
$values = ConvertTo-Json -InputObject $activateBody -Compress
Write-Output $values
$webReturn = Invoke-RestMethod -Method Post -Uri $activateURI -Headers $headers -Body $activateUserJSON
Write-Output $webReturn