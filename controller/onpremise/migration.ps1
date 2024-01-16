function Move-Users {
    param (
        [string]$domainForest,
        [string]$domainEmail,
        [string]$oldOu,
        [string]$newOu
    )

    $option = 'y'

    while ($option -eq 'y') {
        Clear-Host
        Write-Host "Move Users from Old OU to Azure AD Users for AD Synchronization"

        $usernameList = @()

        # Initial input for username
        Write-Host "Enter a username (without @domain). Press Enter twice (blank line) to confirm and proceed."

        do {
            $username = Read-Host
            if ([string]::IsNullOrEmpty($username) -or $username -eq 'q') { break }
            $usernameList += $username
        } while ($true)

        foreach ($user in $usernameList) {
            $userprincipalname = "$user@$domainForest"
            $result = Get-ADUser -Filter "UserPrincipalName -eq '$userprincipalname'"
            
            if (!$result) {

                $userprincipalname = "$user@$domainEmail"
                $result = Get-ADUser -Filter "UserPrincipalName -eq '$userprincipalname'"

                Write-Separator
                Text-Green "$user@$domainEmail has been found. Here is the infomation about it:"
                Get-ADUser -Filter "UserPrincipalName -eq '$userprincipalname'"

            } elseif ($result){

                $result | Set-ADUser -UserPrincipalName $user@$domainEmail
                Write-Separator
                Text-Green "$user@$domainForest has been changed to $user@$domainEmail."
                Write-Host $result | fl
                Get-ADUser -Filter "UserPrincipalName -eq '$userprincipalname'"

            } else {
                Write-Host "User is not found."
            }

            #Write-Host $result.DistinguishedName
            #Write-Host $newOU
            try {
            # Attempt to move the object, but it will try even if it's not found
            Move-ADObject -Identity $result.DistinguishedName -TargetPath $newOU

            # Display a success message
            Write-Separator
            Text-Green "Actions completed for user: $user"

            } catch {
                # Handle any errors that may occur during the Move-ADObject operation
                Write-Host "An error occurred during object move: $($_.Exception.Message)" -ForegroundColor Red
            }
        }

        # Ask if the user wants to run again with a default value of 'n'
        $option = Read-Host "Do you want to run again? (y/n)" -Default 'n'

    }
}
