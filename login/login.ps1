#Connecting to AzureAD environment
function Connect-AAD {

	Clear-Host

	Write-Title "Connecting to Azure AD Environment"
	Connect-AzureAD


}

#Connecting to Exchange Online environment
function Connect-EXO {

	Clear-Host

	Write-Title "Connecting to Exchange Online environment"
	Connect-ExchangeOnline

}

#Connecting to Microsoft365 environment
function Connect-MSO {

	Clear-Host

	Write-Title "Connecting to Microsoft Online environment"
	Connect-MSOlService

}

#Connecting to Microsoft365 Security environment
function Connect-SEC {

	Clear-Host

	Write-Title "Connecting to Microsoft Security/Exchange Online Protection environment"
	Connect-IPPSSession

}

#Connecting to Microsoft Graph environment
function Connect-MGR {

	Clear-Host

	Write-Title "Connecting to Microsoft Graph environment"
	Connect-Mggraph -Scopes Directory.ReadWrite.All, User.ReadWrite.All, Group.ReadWrite.All, UserAuthenticationMethod.ReadWrite.All

}