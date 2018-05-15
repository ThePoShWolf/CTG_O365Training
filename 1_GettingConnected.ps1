Throw "This is a demo, not a script."
<#
    https://docs.microsoft.com/en-us/office365/enterprise/powershell/connect-to-all-office-365-services-in-a-single-windows-powershell-window
#>

#region Prereqs

#required modules
#Earlier versions of Windows: WMF 5.1
https://www.microsoft.com/en-us/download/details.aspx?id=54616
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

#Windows PowerShell needs to be configured to run signed scripts for Skype for Business Online, Exchange Online, and the Security & Compliance Center.
#To do this, run the following command in an elevated Windows PowerShell session (a Windows PowerShell window you open by selecting Run as administrator).

Set-ExecutionPolicy RemoteSigned

#endregion

#region Getting Connected

$domainHost = "howlit"
#Admin credentials for O365
$credential = Get-Credential
#Connect to AzureAD using the $credential
Connect-AzureAD -Credential $credential

#Connect to SharePoint Online
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
Connect-SPOService -Url https://$domainHost-admin.sharepoint.com -credential $credential

#Connect to Skype for Business
Import-Module SkypeOnlineConnector
$sfboSession = New-CsOnlineSession -Credential $credential
Import-PSSession $sfboSession

#Connect to Exchange Online
$exchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $credential -Authentication "Basic" -AllowRedirection
Import-PSSession $exchangeSession

#Connect to the Security and Compliance center
$SccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $credential -Authentication "Basic" -AllowRedirection
Import-PSSession $SccSession
#endregion
