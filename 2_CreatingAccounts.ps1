#region demo
Throw 'This is a demo, dummy!'
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
$license = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses

#retrieve the correct SKU ID
$license.skuid = (Get-AzureADSubscribedSku | Where-Object SKUPartNumber -eq "SMB_Business_Premium").SkuId
$licenses.AddLicenses = $license

#assign the license
Set-AzureADUserLicense -ObjectId $user.UserPrincipalName -AssignedLicenses $licenses

#verify
(Get-AzureADUser -ObjectId $user.UserPrincipalName).AssignedLicenses
$license.SkuId

#endregion