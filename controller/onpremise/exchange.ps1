function Disable-AddressPolicy {
    param (
        [string]$UserEmail
    )

    $mailbox = Get-Mailbox -Identity $UserEmail
    if (-not $mailbox) {
        Text-Red "Mailbox for $UserEmail not found."
        return
    }

    Write-Border "Yellow" -borderChar "-"

    if ($mailbox.EmailAddressPolicyEnabled) {
        Text-Yellow "EmailAddressPolicy for $UserEmail is ENABLED"
        Text-Yellow "Changing the policy..."
        
        try {
            Set-Mailbox -Identity $UserEmail -EmailAddressPolicyEnabled $false
            Write-Border "Yellow" -borderChar "-"
            Text-Green "EmailAddressPolicy for $UserEmail has been DISABLED"
            Write-Border "Yellow" -borderChar "-"
        } catch {
            Text-Red "An error occurred during disabling Email Address Policy for $mailbox.userprincipalname because: $($_.Exception.Message)"
        }
    } else {
        Text-Green "EmailAddressPolicy for $UserEmail is DISABLED"
        Write-Border "Yellow" -borderChar "="
    }

}

function Update-SMTPAddress {
    param (
        [string]$UserEmail
    )

    $allowedDomains = @(
        'astrainfra.co.id',
        'astrainfra.mail.onmicrosoft.com',
        'astrainfra.onmicrosoft.com'
    )

    $mailbox = Get-Mailbox -Identity $UserEmail
    if (-not $mailbox) {
        Text-Red "Mailbox for $UserEmail not found."
        return
    }

    $emailAddresses = $mailbox.EmailAddresses | Where-Object {
        $_ -ne $null -and $_.ToString().ToLower().EndsWith(($_.ToString().Split('@')[-1]).ToLower())
    }

    $newAddresses = @()

    # Add allowed addresses
    $localPart = $UserEmail.Split('@')[0] # Extracts the part before the '@'
    foreach ($domain in $allowedDomains) {
        $addressToAdd = "smtp:$localPart@$domain"
        if (-not ($emailAddresses -contains $addressToAdd)) {
            $newAddresses += $addressToAdd
            Text-Green "$addressToAdd has been added to $UserEmail."
        } else {
            Text-Green "$addressToAdd already exists."
        }
    }

    # Filter out unwanted addresses but keep X500 addresses
    $filteredAddresses = $emailAddresses | Where-Object {
        $domainPart = $_.ToString().Split('@')[-1].ToLower()
        
        # If it's an X500 address, keep it
        if ($_.ToString().StartsWith("X500:")) {
            return $true
        }
        
        # If it's an allowed domain, keep it
        if ($allowedDomains -contains $domainPart) {
            return $true
        }
        
        # If none of the above conditions are met, it's an unwanted address
        Text-Yellow "DELETED $_"
        return $false
    }

    # Combine the filtered and new addresses
    $combinedAddresses = @($filteredAddresses) + @($newAddresses)

    # Update the mailbox
    try {
        Set-Mailbox -Identity $UserEmail -EmailAddresses $combinedAddresses
        Text-Green "SMTP Address of $UserEmail has been edited Successfully."
    } catch {
        Text-Red "SMTP Address of $UserEmail has not been edited. The error is: $($_.Exception.Message)"
    }
    Write-Border "Green" -borderChar "="
}

function Set-AllExchangeUsers {
    param(
        [Parameter(Mandatory=$true)]
        [string]$domain
    )

    $wildcard = "*@$domain"

    do{
        Clear-Host
        Write-Title "Setup SMTP Addresses for Migration"

        $mailboxes = Get-Mailbox -ResultSize Unlimited | Where-Object { $_.PrimarySmtpAddress -like $wildcard }
        foreach ($mailbox in $mailboxes) {
            try {
                Disable-AddressPolicy -UserEmail $mailbox
                Text-Green "Successfully disable Email Address Policy for $mailbox.userprincipalname."
            } catch {
                Text-Red "An error occurred during disabling Email Address Policy for $mailbox.userprincipalname because: $($_.Exception.Message)"
            }

            try {
                Update-SMTPAddress -UserEmail $mailbox
                Text-Green "Successfully added onmicrosoft SMTP for $mailbox"
            } catch {
                Text-Red "An error occured during adding onmicrosoft SMTP for $mailbox.userprincipalname because: $($_.Exception.Message)"
            }
        }

        $option = Read-Host "Do you want to run again? (y/n)" -Default 'n'
    } while ($option -eq 'y')
}