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
    
    if (-not $user) {
        $userprincipalname = "$username@$domainEmail"
        $user = Get-ADUser -Filter "UserPrincipalName -eq '$userprincipalname'"
    }

    if ($user) {
        try {
            Move-ADObject -Identity $user.DistinguishedName -TargetPath $newOu

            Write-Border -borderChar "-"
            Text-Green "Moved user $userprincipalname to $newOu." -ForegroundColor Green
            Write-Border -borderChar "-"

            Write-Host "BEFORE MIGRATION"
            Get-ADUser -Filter "UserPrincipalName -eq '$userprincipalname'"

            Write-Border -borderChar "-"
            Write-Host "AFTER MIGRATION"
            Get-ADUser -Filter "UserPrincipalName -eq '$userprincipalname'"
            Write-Border -borderChar "="
        } catch {
            Text-Red "An error occurred during object move: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Border "Red" -borderChar "-"
        #Text-Cyan "$userprincipalname"
        Text-Red "$userprincipalname not found in both domain forests." -ForegroundColor Red
        Write-Border "Red" -borderChar "="
    }
}

function Move-Users {
    param (
        [string]$domainForest,
        [string]$domainEmail,
        [string]$oldOu,
        [string]$newOu
    )

    Clear-Host
    Write-Title "Move Users from Old OU to Azure AD Users for AD Synchronization"

    do {
        $upnList = Get-UserFromUPN -domainForest $domainForest

        foreach ($username in $upnList) {
            Move-UserToAzureOU -username $username -domainForest $domainForest -domainEmail $domainEmail -newOu $newOu
        }

        $option = Read-Host "Do you want to run again? (y/n)" -Default 'n'
    } while ($option -eq 'y')
}

function Return-Users {
    param (
        [string]$domainForest,
        [string]$domainEmail,
        [string]$oldOu,
        [string]$newOu
    )

    Clear-Host
    Write-Title "Move Users from Old OU to Azure AD Users for AD Synchronization"

    do {
        $upnList = Get-UserFromUPN -domainForest $domainForest

        foreach ($username in $upnList) {
            Move-UserToAzureOU -username $username -domainForest $domainForest -domainEmail $domainEmail -newOu $oldOu
        }

        $option = Read-Host "Do you want to run again? (y/n)" -Default 'n'
    } while ($option -eq 'y')
}