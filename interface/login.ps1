# Import the module/script that contains the necessary functions
. .\common\function.ps1
. .\common\interface.ps1
. .\controller\login.ps1
. .\controller\onpremise\login.ps1
. .\controller\onpremise\activedirectory.ps1
. .\interface\onpremise\dashboard.ps1
. .\tools\atn-tools.ps1

function Show-LoginPage {

    #State-Variables

    while ($true) {
        Clear-Host
        Write-Title "LET'S LOGIN BEFORE WE GO"

        Write-Host "1. Login to Azure AD"
        Write-Host "2. Login to Exchange Online"
        Write-Host "3. Login to Microsoft Admin (MSOLService)"
        Write-Host "4. Login to Security (IPPSSession)"
        Write-Host "5. Login to Microsoft Graph"
        Write-Host "6. Login to All Services"
        Write-Host "7. Choose what you want to login"
        Text-Blue "8. I have logged in to what I want"
        Write-Separator
        Write-Host "10. Connect To Servers (Domain Controller, Exchange, AD Connect)"
        Text-Blue "11. I have logged in to the server I want"
        Write-Separator
        Text-Yellow "21. Have not installed one of the module yet?"
        Write-Separator
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
            '10'{
                Connect-Servers
            }
            '11'{
                Migration-Menu
                Wait-Key
            }
            '21' {
                # Logic to install required modules
            }
            '96' {
                Pull-M365Tools
            }
            '97' {
                Push-M365Tools
            }
            '98' {
                Compress-M365Tools
            }
            '99' {
                Copy-M365Tools
            }
            '0' { 
                Clear-Host
                Write-Danger "You have exited the script."
                return
            }
            default {
                Wait-Key -info "Invalid option, please try again." -TextColor "Red"
            }
        }
    }
}