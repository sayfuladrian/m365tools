# Import the module/script that contains the necessary functions
. .\common\function.ps1
. .\common\interface.ps1
. .\controller\login.ps1

function Show-LoginPage {
    Clear-Host
    Write-Title "LET'S LOGIN BEFORE WE GO"

    Write-Host "1. Login to Azure AD"
    Write-Host "2. Login to Exchange Online"
    Write-Host "3. Login to Microsoft Admin (MSOLService)"
    Write-Host "4. Login to Security (IPPSSession)"
    Write-Host "5. Login to Microsoft Graph"
    Write-Host "6. Login to All Services"
    Write-Host "7. Choose what you want to login"

    # Using Text-Blue from interface.ps1 to print blue text
    Text-Blue "8. I have logged in to what I want"
    Write-Separator

    # Using Text-Red from interface.ps1 to print red text
    Text-Red "0. Quit"

    $choice = Read-Host "Please enter your choice"

    switch ($choice) {
        '1' { Connect-AAD }
        '2' { Connect-EXO }
        '3' { Connect-MSO }
        '4' { Connect-SEC }
        '5' { Connect-MGR }
        '6' {
            Connect-AAD
            Connect-EXO
            Connect-MSO
            Connect-SEC
            Connect-MGR
        }
        '7' {
            # Implement the logic for the user to choose the services to log in
        }
        '8' {
            # Check login status or proceed further if the user confirms they have logged in
        }
        '0' { 
            Clear-Host
            Write-Danger "You have Exited the Script"
            return
        }
        default { 
            Write-Host "Invalid option, please try again."
            Show-LoginPage
        }
    }
}