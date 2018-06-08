#region demo
Throw "This is a demo, not a script."
<#
    https://docs.microsoft.com/en-us/office365/enterprise/powershell/connect-to-all-office-365-services-in-a-single-windows-powershell-window
#>
#endregion

#region prep
function prompt(){}
Clear-Host
#endregion

#region Prereqs
#Earlier versions of Windows: WMF 5.1
https://www.microsoft.com/en-us/download/details.aspx?id=54616

#region required modules

#AzureAD
Install-Module -Name AzureAD
Update-Module -Name AzureAD

#SharePoint Online
https://www.microsoft.com/en-us/download/details.aspx?id=35588

#Skype for Business Online
https://www.microsoft.com/en-us/download/details.aspx?id=39366

#Teams
Install-Module -Name MicrosoftTeams
Update-Module -Name MicrosoftTeams

#Exchange
#Nothing needed
#endregion

#region executionpolicy

<#
Windows PowerShell needs to be configured to run signed scripts for Skype for Business Online,
Exchange Online, and the Security & Compliance Center.
#>

Set-ExecutionPolicy RemoteSigned -Confirm:$false
#endregion
#endregion

#region Getting Connected

$domainHost = "office365courses"

#Admin credentials for O365
$credential = Get-Credential
$credential.Password.MakeReadOnly()

#Connect to AzureAD using the $credential
Connect-AzureAD -Credential $credential

#Connect to Microsoft Teams using the $credential
Connect-MicrosoftTeams -Credential $credential

#Connect to SharePoint Online
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
Connect-SPOService -Url https://$domainHost-admin.sharepoint.com -credential $credential

#Connect to the Security and Compliance center
$SccSessionParams = @{
    'ConfigurationName' = 'Microsoft.Exchange'
    'ConnectionUri' = 'https://ps.compliance.protection.outlook.com/powershell-liveid/'
    'Credential' = $credential
    'Authentication' = 'Basic'
    'AllowRedirection' = $true
}
$SccSession = New-PSSession
Import-PSSession $SccSession

#Connect to Exchange Online
$ExchangeSessionParams = @{
    'ConfigurationName' = 'Microsoft.Exchange'
    'ConnectionUri' = "https://outlook.office365.com/powershell-liveid/"
    'Credential' = $credential
    'Authentication' = 'Basic'
    'AllowRedirection' = $true
}
$exchangeSession = New-PSSession  @ExchangeSessionParams
Import-PSSession $exchangeSession

#Connect to Skype for Business
Import-Module SkypeOnlineConnector
$sfboSession = New-CsOnlineSession -Credential $credential
Import-PSSession $sfboSession

#endregion
