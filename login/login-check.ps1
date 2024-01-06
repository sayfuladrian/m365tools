#Check if AzureAD has properly connected
function Check-AAD {
	param (
		[Parameter(Mandatory=$true)]
		[scriptblock]$Function
	)

	try {

		& $Function

	}

	catch {

		switch ($_.Exception.Message) { 
			
			{ $_ -like "*Connect-AzureAD*" } {

				Write-Host "Make sure you connect to AzureAD first before run this script."

			}
			{ $_ -like "*no AzureAD users found*" } {

				Write-Host "No AzureAD users were found."

			}
			{ $_ -like "*AccessDenied*" } {

				Write-Host "You have insufficient privilege. Make sure you have logged into the correct account"

			}
			{ $_ -like "*Network*" } {

				Write-Host "There is an issue on you network. Run the command again or, if still error, try to close your powershell session and run again."

			}
			{ $_ -like "*Invalid Credentials*" } {

				Write-Host "Invalid Credentials. Check your username or password."

			} 
			{ $_ -like "*ServiceUnavailable*" } {

				Write-Host "Azure AD service is currently unavailable. Please try again later."

			} 
			{ $_ -like "*Timeout*" } {

				Write-Host "The request to Azure AD timed out. Please check your network"

			}
			{ $_ -like "*API error*" } {

                Write-Host "An error occurred with the Azure AD API. Please check the API status."

            }
            { $_ -like "*QuotaExceeded*" } {

                Write-Host "Quota for Azure AD requests exceeded. Consider reviewing your usage limits."

            }
            { $_ -like "*Unexpected data format*" } {

                Write-Host "Unexpected data format received from Azure AD. Data may be corrupted."

            }
            default {

                Write-Error "An unexpected error occurred: $_"

            }

		}

	}
	
}

#Get Azure AD Status 
function Get-AADStatus {

	$scriptblock = { Get-AzureADUser | Select-Object -First 1 | Format-Table }
	Check-AAD -Function $scriptblock

}

#Check if Exchange Online has properly connected
function Check-EXO {
    param (
        [Parameter(Mandatory=$true)]
        [scriptblock]$Function
    )

    try {
        & $Function
    }
    catch {
        switch ($_.Exception.Message) {
            { $_ -like "*Not connected to Exchange Online*" } {
                Write-Host "Please connect to Exchange Online before running this script."
            }
            { $_ -like "*No mailboxes found*" } {
                Write-Host "No mailboxes were found. Please check your Exchange Online configuration."
            }
            { $_ -like "*AccessDenied*" } {
                Write-Host "Access denied. Please check your permissions."
            }
            { $_ -like "*Network*" } {
                Write-Host "Network issue detected. Please check your network connection."
            }
            { $_ -like "*Invalid Credentials*" } {
                Write-Host "Invalid credentials. Please verify your username and password."
            }
            { $_ -like "*ServiceUnavailable*" } {
                Write-Host "Exchange Online service is currently unavailable. Please try again later."
            }
            { $_ -like "*Timeout*" } {
                Write-Host "The request to Exchange Online timed out. Please try again."
            }
            { $_ -like "*API error*" } {
                Write-Host "An error occurred with the Exchange Online API. Please check the API status."
            }
            { $_ -like "*QuotaExceeded*" } {
                Write-Host "Quota for Exchange Online requests exceeded. Consider reviewing your usage limits."
            }
            { $_ -like "*Unexpected data format*" } {
                Write-Host "Unexpected data format received from Exchange Online. Data may be corrupted."
            }
            default {
                Write-Error "An unexpected error occurred: $_"
            }
        }
    }
}

#Get Exchange Online Status 
function Get-EXOStatus {

	$scriptblock = { Get-Mailbox | Select-Object -First 1 | ft }
	Check-EXO -Function $scriptblock

}

#Check if MS Online has properly connected
function Check-MSO {
    param (
        [Parameter(Mandatory=$true)]
        [scriptblock]$Function
    )

    try {
        & $Function
    }
    catch {
        switch ($_.Exception.Message) {
            { $_ -like "*Not connected to MSOLService*" } {
                Write-Host "Please connect to MSOLService before running this script."
            }
            { $_ -like "*License information unavailable*" } {
                Write-Host "Unable to retrieve license information. Please check your MSOLService configuration."
            }
            { $_ -like "*AccessDenied*" } {
                Write-Host "Access denied. Please check your permissions."
            }
            { $_ -like "*Network*" } {
                Write-Host "Network issue detected. Please check your network connection."
            }
            { $_ -like "*Invalid Credentials*" } {
                Write-Host "Invalid credentials. Please verify your username and password."
            }
            { $_ -like "*ServiceUnavailable*" } {
                Write-Host "MSOLService is currently unavailable. Please try again later."
            }
            { $_ -like "*Timeout*" } {
                Write-Host "The request to MSOLService timed out. Please try again."
            }
            { $_ -like "*API error*" } {
                Write-Host "An error occurred with the MSOLService API. Please check the API status."
            }
            { $_ -like "*QuotaExceeded*" } {
                Write-Host "Quota for MSOLService requests exceeded. Consider reviewing your usage limits."
            }
            { $_ -like "*Unexpected data format*" } {
                Write-Host "Unexpected data format received from MSOLService. Data may be corrupted."
            }
            default {
                Write-Error "An unexpected error occurred: $_"
            }
        }
    }
}

function Get-MSOStatus {
    $scriptblock = { Get-MsolUser | Select-Object -First 1 | Format-Table }
    Check-MSO -Function $scriptblock
}

function Check-MSO {
    param (
        [Parameter(Mandatory=$true)]
        [scriptblock]$Function
    )

    try {
        & $Function
    }
    catch {
        switch ($_.Exception.Message) {
            { $_ -like "*Not connected to MSOLService*" } {
                Write-Host "Please connect to MSOLService before running this script."
            }
            { $_ -like "*License information unavailable*" } {
                Write-Host "Unable to retrieve license information. Please check your MSOLService configuration."
            }
            { $_ -like "*AccessDenied*" } {
                Write-Host "Access denied. Please check your permissions."
            }
            { $_ -like "*Network*" } {
                Write-Host "Network issue detected. Please check your network connection."
            }
            { $_ -like "*Invalid Credentials*" } {
                Write-Host "Invalid credentials. Please verify your username and password."
            }
            { $_ -like "*ServiceUnavailable*" } {
                Write-Host "MSOLService is currently unavailable. Please try again later."
            }
            { $_ -like "*Timeout*" } {
                Write-Host "The request to MSOLService timed out. Please try again."
            }
            { $_ -like "*API error*" } {
                Write-Host "An error occurred with the MSOLService API. Please check the API status."
            }
            { $_ -like "*QuotaExceeded*" } {
                Write-Host "Quota for MSOLService requests exceeded. Consider reviewing your usage limits."
            }
            { $_ -like "*Unexpected data format*" } {
                Write-Host "Unexpected data format received from MSOLService. Data may be corrupted."
            }
            default {
                Write-Error "An unexpected error occurred: $_"
            }
        }
    }
}

function Get-MSOStatus {

    $scriptblock = { Get-MsolUser | Select-Object -First 1 | Format-Table }
    Check-MSO -Function $scriptblock

}

#Check if IPPSSession has properly connected
function Check-SEC {
    param (
        [Parameter(Mandatory=$true)]
        [scriptblock]$Function
    )

    try {
        & $Function
    }
    catch {
        switch ($_.Exception.Message) {
            { $_ -like "*Not connected to IPPSSession Service*" } {
                Write-Host "Please connect to IPPSSession Service before running this script."
            }
            { $_ -like "*Data retrieval issue*" } {
                Write-Host "Issue with retrieving data from IPPSSession Service."
            }
            { $_ -like "*AccessDenied*" } {
                Write-Host "Access denied. Please check your permissions."
            }
            { $_ -like "*Network*" } {
                Write-Host "Network issue detected. Please check your network connection."
            }
            { $_ -like "*Invalid Credentials*" } {
                Write-Host "Invalid credentials. Please verify your username and password."
            }
            { $_ -like "*ServiceUnavailable*" } {
                Write-Host "IPPSSession Service is currently unavailable. Please try again later."
            }
            { $_ -like "*Timeout*" } {
                Write-Host "The request to IPPSSession Service timed out. Please try again."
            }
            { $_ -like "*API error*" } {
                Write-Host "An error occurred with the IPPSSession Service API. Please check the API status."
            }
            { $_ -like "*QuotaExceeded*" } {
                Write-Host "Quota for IPPSSession Service requests exceeded. Consider reviewing your usage limits."
            }
            { $_ -like "*Unexpected data format*" } {
                Write-Host "Unexpected data format received from IPPSSession Service. Data may be corrupted."
            }
            default {
                Write-Error "An unexpected error occurred: $_"
            }
        }
    }
}

function Get-SECStatus {

    $scriptblock = { # Replace this with an actual command related to IPPSSession }
    Check-SEC -Function $scriptblock

}

