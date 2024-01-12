. .\controller\login-check.ps1
. .\common\interface.ps1

#Connecting to AzureAD environment
function Connect-AAD {

	Clear-Host

	Write-Title "Connecting to Azure AD Environment"
	Connect-AzureAD
	
	Get-AADStatus

}

#Connecting to Exchange Online environment
function Connect-EXO {

	Clear-Host

	Write-Title "Connecting to Exchange Online environment"
	Connect-ExchangeOnline

	Get-EXOStatus

}

#Connecting to Microsoft365 environment
function Connect-MSO {

	Clear-Host

	Write-Title "Connecting to Microsoft Online environment"
	Connect-MSOlService

	Get-MSOStatus

}

#Connecting to Microsoft365 Security environment
function Connect-SEC {

	Clear-Host

	Write-Title "Connecting to Microsoft Security/Exchange Online Protection environment"
	Connect-IPPSSession

	Get-SECStatus

}

#Connecting to Microsoft Graph environment
function Connect-MGR {

	Clear-Host

	Write-Title "Connecting to Microsoft Graph environment"
	Connect-Mggraph -Scopes Directory.ReadWrite.All,User.ReadWrite.All,Group.ReadWrite.All,UserAuthenticationMethod.ReadWrite.All

	Get-MGRStatus

}