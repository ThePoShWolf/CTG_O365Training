#region demo
Throw 'This is a demo, dummy!'
#endregion

#region connection
#Admin credentials for O365
$credential = Get-Credential

Connect-AzureAD -Credential $credential

$exchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $credential -Authentication "Basic" -AllowRedirection
Import-PSSession $exchangeSession

#endregion connection

#region prep
Function Prompt(){}
Clear-Host
Remove-AzureADUser -ObjectID Rick.Sanchez@howell-it.com
#endregion

#region create user

#connect to AzureAD
$credential = Get-Credential
Connect-AzureAD -Credential $credential

#create the password profile
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "bqQr5b9HT"
$PasswordProfile.EnforceChangePasswordPolicy = $true
$PasswordProfile.ForceChangePasswordNextLogin = $true

#splat
$user = @{
    'PasswordProfile' = $PasswordProfile
    'AccountEnabled' = $true
    'UserPrincipalName' = 'Rick.Sanchez@howell-it.com'
    'DisplayName' = 'Rick Sanchez'
    'MailNickName' = 'RickSanchez'
    'UsageLocation' = 'US'
}

#create the user
New-AzureADUser @User

#verify
Get-AzureADUser -ObjectId $user.UserPrincipalName

#check licenses
Get-AzureADUser -ObjectId $user.UserPrincipalName | Format-Table AssignedLicenses
#Remove-AzureADUser -ObjectId $user.UserPrincipalName
#endregion

#region assign licenses
#create license objects
$licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$license = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense

#retrieve the correct SKU ID
Get-AzureADSubscribedSku
$license.skuid = (Get-AzureADSubscribedSku | Where-Object SKUPartNumber -eq "SMB_Business_Premium").SkuId
$license.SkuId
$licenses.AddLicenses = $license

#assign the license
Set-AzureADUserLicense -ObjectId $user.UserPrincipalName -AssignedLicenses $licenses

#verify
Get-AzureADUser -ObjectId $user.UserPrincipalName | Format-List AssignedLicenses

#endregion