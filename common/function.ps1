# Function to handle warnings and add to the $warnings array
function Handle-Warning {
    param([string]$message)
    $global:warnings += $message
}

# Function to print collected warnings
function Print-Warnings {
    $global:warnings | ForEach-Object { Write-Warning $_ }
}

# Function to handle errors
function Handle-Error {
    param (
        [string]$errorMessage
    )

    switch -Regex ($errorMessage) {
        "You must call the Connect-MsolService cmdlet" {
            Text-Yellow "Please connect to MSOLService before running this script."
        }
        "Authentication needed. Please call Connect-MgGraph." {
            Text-Yellow "Please Connect to Microsoft Graph before running this script."
        }
        default {
            Text-Red "An error occurred: $errorMessage"
        }
    }
}

#Check if AzureAD has properly connected
function Check-Error {
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
                Text-Yellow "Please connect to Azure AD before running this script."
            }
            { $_ -like "*'Get-Mailbox' is not recognized*" } {
                Text-Yellow "Please connect to Exchange Online before running this script."
            }
            { $_ -like "*You must call the Connect-MsolService*" } {
                Text-Yellow "Please connect to MSOLService before running this script."
            }
            { $_ -like "*'Get-Label' is not recognized*" } {
                Text-Yellow "Please connect to IPPSSession Service before running this script."
            }
            { $_ -like "*Authentication needed. Please call Connect-MgGraph.*" } {
                Text-Yellow "Please Connect to Microsoft Graph before running this script."
            }
            { $_ -like "*no AzureAD users found*" -or $_ -like "*No mailboxes found*" -or $_ -like "*License information unavailable*" -or $_ -like "*Data retrieval issue*" } {
                Text-Yellow "Issue with retrieving data. Please check your configuration."
            }
            { $_ -like "*AccessDenied*" } {
                Text-Yellow "Access denied. Please check your permissions."
            }
            { $_ -like "*Network*" } {
                Text-Yellow "Network issue detected. Please check your network connection."
            }
            { $_ -like "*Invalid Credentials*" } {
                Text-Yellow "Invalid credentials. Please verify your username or password."
            }
            { $_ -like "*ServiceUnavailable*" -or $_ -like "*MSOLService is currently unavailable.*" -or $_ -like "*Exchange Online service is currently unavailable.*" -or $_ -like "*IPPSSession Service is currently unavailable.*" } {
                Text-Yellow "Service is currently unavailable. Please try again later."
            }
            { $_ -like "*Timeout*" } {
                Text-Yellow "The request timed out. Please try again."
            }
            { $_ -like "*API error*" } {
                Text-Yellow "An error occurred with the API. Please check the API status."
            }
            { $_ -like "*QuotaExceeded*" } {
                Text-Yellow "Quota for requests exceeded. Consider reviewing your usage limits."
            }
            { $_ -like "*Unexpected data format*" } {
                Text-Yellow "Unexpected data format received. Data may be corrupted."
            }
            default {
                Write-Error "An unexpected error occurred: $_"
            }
        }

	}
	
}