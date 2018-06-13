#region demo
Throw 'This is a demo, dummy!'
#endregion

#region prep
Function Prompt(){}
Clear-Host
Remove-AzureADUser -ObjectID Rick.Sanchez@office365courses.com
#endregion

#region connection

#Admin credentials for O365
$credential = Get-Credential

#In case we're not connected from part 1:
Connect-AzureAD -Credential $credential

#endregion connection

#region create user

#create the password profile
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "bqQr5b9HT"

#These default to true, but to demonstrate:
$PasswordProfile.EnforceChangePasswordPolicy = $true
$PasswordProfile.ForceChangePasswordNextLogin = $true

#splat
$user = @{
    'PasswordProfile' = $PasswordProfile
    'AccountEnabled' = $true
    'UserPrincipalName' = 'Rick.Sanchez@office365courses.com'
    'DisplayName' = 'Rick Sanchez'
    'MailNickName' = 'RickSanchez'
    'UsageLocation' = 'US'
}

#region no splat
New-AzureADUser -PasswordProfile $PasswordProfile -AccountEnabled $true -UserPrincipalName 'Rick.Sanchez@office365courses.com' -DisplayName 'Rick Sanchez' -MailNickName = 'RickSanchez' -UsageLocation = 'US'
#endregion

#create the user
New-AzureADUser @User

#verify
Get-AzureADUser -ObjectId 'Rick.Sanchez@office365courses.com'

#check licenses
Get-AzureADUser -ObjectId 'Rick.Sanchez@office365courses.com' | Select-Object -ExpandProperty AssignedLicenses

#endregion

#region assign licenses

#create license objects
$licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$license = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense

#retrieve the correct SKU ID
Get-AzureADSubscribedSku
$license.skuid = (Get-AzureADSubscribedSku | Where-Object SKUPartNumber -eq "EXCHANGESTANDARD").SkuId
$license.SkuId
$licenses.AddLicenses = $license

#assign the license
Set-AzureADUserLicense -ObjectId 'Rick.Sanchez@office365courses.com' -AssignedLicenses $licenses

#verify
Get-AzureADUser -ObjectId 'Rick.Sanchez@office365courses.com' | Select-Object -ExpandProperty AssignedLicenses

#endregion