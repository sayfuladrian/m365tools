function Get-Username {
    Write-Host "Enter usernames (without @domain). Press Enter twice (blank line) to confirm and proceed."
    $usernameList = @()

    do {
        $username = Read-Host
        if ([string]::IsNullOrEmpty($username)) { break }
        $usernameList += $username
    } while ($true)

    return $usernameList
}

function Get-UserPrincipalName {
    param (
        [string]$domainForest
    )

    $usernameList = Get-Username
    $upnList = @()
    foreach ($username in $usernameList) {
        $upnList += "$username@$domainForest"
    }

    return $upnList
}

function Get-UserEmail {
    param (
        [string]$domainEmail
    )

    $usernameList = Get-Username
    $emailList = @()
    foreach ($username in $usernameList) {
        $emailList += "$username@$domainEmail"
    }

    return $emailList
}

function Get-UserFromUPN {
    param (
        [string]$domainForest
    )

    Write-Host "Enter a username (without @domain). Press Enter twice (blank line) to confirm and proceed."
    $usernameList = @()

    do {
        $username = Read-Host
        if ([string]::IsNullOrEmpty($username)) { break }
        $usernameList += "$username"
    } while ($true)

    return $usernameList
}

function Move-UserToAzureOU {
    param (
        [string]$username,
        [string]$domainForest,
        [string]$domainEmail,
        [string]$newOu
    )

    $userprincipalname = "$username@$domainForest"
    $user = Get-ADUser -Filter "UserPrincipalName -eq '$userprincipalname'"
    Write-Host "$user.DistinguishedName"
    
    if (-not $user) {
        $userprincipalname = "$username@$domainEmail"
        $user = Get-ADUser -Filter "UserPrincipalName -eq '$userprincipalname'"
    }

    Write-Border -borderChar "-"
    Text-Green "Moved user $userprincipalname to $newOu." -ForegroundColor Green
    Write-Border -borderChar "-"

    Write-Host "BEFORE MIGRATION"
    Get-ADUser -Filter "UserPrincipalName -eq '$userprincipalname'"

    if ($user) {
        try {
            Move-ADObject -Identity $user.DistinguishedName -TargetPath $newOu

            Write-Border -borderChar "-"
            Write-Host "AFTER MIGRATION"
            Get-ADUser -Filter "UserPrincipalName -eq '$userprincipalname'"
            Write-Border -borderChar "="
        } catch {
            Text-Red "An error occurred during object move: $($_.Exception.Message)"
        }
    } else {
        Write-Border "Red" -borderChar "-"
        #Text-Cyan "$userprincipalname"
        Text-Red "$userprincipalname not found in both domain forests." -ForegroundColor Red
        Write-Border "Red" -borderChar "="
    }
}

function Get-Guid {

    do {
        $username = Get-username

        Clear-Host
        Write-Title "Get Object ID or GUID to do hardmatch"

        foreach ($user in $username){
            $id = Get-ADUser -Identity $user -Properties objectGUID
            $immutableId = [System.Convert]::ToBase64String($id.objectGUID.ToByteArray())
            Text-Green "$immutableId"
        }
        $option = Read-Host "Do you want to run again? (y/n)" -Default 'n'

    } while ($option -eq 'y')
}

function Move-Users {
    param (
        [string]$domainForest,
        [string]$domainEmail,
        [string]$oldOu,
        [string]$newOu
    )

    do {
        $upnList = Get-UserFromUPN -domainForest $domainForest

        Clear-Host
        Write-Title "Move Users from Old OU to Azure AD Users for AD Synchronization"

        foreach ($username in $upnList) {
            Move-UserToAzureOU -username $username -domainForest $domainForest -domainEmail $domainEmail -newOu $newOu
            Disable-AddressPolicy -useremail "$username@$domainEmail"
            Update-SMTPAddress -useremail "$username@$domainEmail"
        }

        $option = Read-Host "Do you want to run again? (y/n)" -Default 'n'
    } while ($option -eq 'y')
}