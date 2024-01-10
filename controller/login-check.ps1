. ..\common\function.ps1
. ..\common\interface.ps1

#Get Azure AD Status 
function Get-AADStatus {

	$scriptblock = {
        $global:WarningPreference = "SilentlyContinue"
        $result = Get-AzureADUser -Top 1
        if ($result) {
            Text-Green "You have connected to AzureAD"
        }
        $global:WarningPreference = "Continue"
    }
	Check-Error -Function $scriptblock

}

#Get Exchange Online Status 
function Get-EXOStatus {

	$scriptblock = { 
        $global:WarningPreference = "SilentlyContinue"
        $result = Get-Mailbox -ResultSize 1
        if ($result) {
            Text-Green "You have connected to Exchange Online Management"
        }
        $global:WarningPreference = "Continue"
    }
	Check-Error -Function $scriptblock

}

# Check if MS Online has properly connected
function Get-MSOStatus {
    $scriptblock = {
        $global:WarningPreference = "SilentlyContinue"
        try {
            # Check if MSOLService is connected
            Get-MsolDomain -ErrorAction Stop | Out-Null
            Text-Green "You have connected to MSOnline Service"
        } catch {
            if ($_.Exception.GetType().FullName -eq 'MicrosoftOnlineException') {
                Text-Yellow "Please connect to MSOLService before running this script."
            } else {
                Handle-Error -errorMessage $_.Exception.Message
            }
        }
        $global:WarningPreference = "Continue"
    }
    Check-Error -Function $scriptblock
}

#Check if IPPSSession has properly connected
function Get-SECStatus {

    $scriptblock = { 
        $global:WarningPreference = "SilentlyContinue"
        $result = Get-Label 
        if ($result) {
            Text-Green "You have connected to IPPSSession"
        }
        $global:WarningPreference = "Continue"
    }
    Check-Error -Function $scriptblock

}

function Get-MGRStatus {
    $scriptblock = {
        $global:WarningPreference = "SilentlyContinue"
        try {
            $result = Get-MgUser -Top 1
            if ($result) {
                Text-Green "You have connected to Microsoft Graph"
            }
        } catch {
            # Check if the last error is an authentication error
            if ($Error[0].Exception.Message -match "Authentication needed. Please call Connect-MgGraph") {
                Write-Host "Please Connect Microsoft Graph before running this command"
            } else {
                # If it's a different type of error, handle it accordingly
                Handle-Error -errorMessage $_.Exception.Message
            }
        }
        $global:WarningPreference = "Continue"
    }
    Check-Error -Function $scriptblock
}