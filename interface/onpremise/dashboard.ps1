$onpremiseDomain = "astratel.co.id"
$emailDomain = "astrainfra.co.id"
$onpremiseOldOU = "CN=users,OU=astratel,OU=co,OU=id"
$onpremiseNewOU = "OU=Azure AD Users,OU=Astratel,DC=astratel,DC=co,DC=id"

function Migration-Menu {
    param(
        [string]$filePath = ".\controller\onpremise\db-ou.txt"
    )

    Clear-Host
    Write-Title "Welcome to the Migration Menu for ONPREMISE"

    Text-Cyan "1. Move OU from old OU to the NEW AZURE AD OU for Synchronization"
    Text-Cyan "2. Add SMTP Record: onmicrosoft.com to the User Properties"
    Text-Cyan "3. Replicate Synchronization across Domain Controller"
    Text-Cyan "4. Disable or Remove Mailbox (Only Mailbox)"
    Text-Cyan "5. Create Remote Mailbox"
    Text-Cyan "6. Get ImmutableID for Hard Match"
    Write-Separator
    Text-Cyan "10. Move back the users from NEW AZURE AD OU to old OU"
    Text-Cyan "11. Enable Recycle Bin for Active Directory"
    $choice = Read-Host "Enter your choice"

    switch ($choice) {
        '1' {
            Move-Users -domainForest $onpremiseDomain -domainEmail $emailDomain -oldOu $onpremiseOldOU -newOu $onpremiseNewOU
        }
        '2' {
            Set-AllExchangeUsers -domain $emailDomain
        }
        '3' {
            
        }
        '6' {
            Get-Guid
            Wait-Key
        }
        '10' { 
            Move-Users -domainForest $onpremiseDomain -domainEmail $emailDomain -oldOu $onpremiseNewOU -newOu $onpremiseOldOU
        }
        default {
            Write-Host "Invalid option selected."
        }
    }
}