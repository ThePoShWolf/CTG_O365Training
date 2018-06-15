#region demo
Throw 'This is a demo, dummy!'
#endregion

#region prep
Remove-AzureADGroup -ObjectId (get-azureadgroup -SearchString 'underground').objectid
Remove-AzureADGroup -ObjectId (get-azureadgroup -SearchString 'smartest beings').objectid
Function Prompt(){}
Clear-Host
#endregion

#region connect
$credential = Get-Credential
Connect-AzureAD -Credential $credential
#endregion

#region Reset a user password
$passwordChange = @{
    'ObjectId' = 'rick.sanchez@office365courses.com' 
    'Password' = '@wes0me!'
    'ForceChangePasswordNextLogin' = $false
    'EnforceChangePasswordPolicy' = $true
}
Set-AzureADUserPassword @passwordChange

#no splat
Set-AzureADUserPassword -ObjectId 'rick.sanchez@office365courses.com' -Password '@wes0me!' -ForceChangePasswordNextLogin $false -EnforceChangePasswordPolicy $true

#endregion

#region Creating groups

#security enabled group
$SecurityEnabled = @{
    'DisplayName' = 'Underground Lair Admins'
    'SecurityEnabled' = $true
    'MailEnabled' = $false
    'MailNickName' = 'null'
}
New-AzureADGroup @SecurityEnabled

#No Splat
New-AzureADGroup -DisplayName 'Underground Lair Admins' -SecurityEnabled $true -MailEnabled $false -MailNickName 'null'

#mail enabled group
$MailEnabled = @{
    'DisplayName' = 'Smartest Beings'
    'SecurityEnabled' = $false
    'MailEnabled' = $true
    'MailNickName' = 'SmartestBeings'
}
New-AzureADGroup @MailEnabled

#No Splat
New-AzureADGroup -DisplayName 'Smartest Beings' -SecurityEnabled $false -MailEnabled $true -MailNickName 'SmartestBeings'

#endregion 

#region Add and removing user from/to groups
#retrieve appropriate ObjectIds
$ULA = Get-AzureADGroup -Filter "DisplayName eq 'Underground Lair Admins'"
$Rick = Get-AzureADUser -ObjectId 'Rick.Sanchez@office365courses.com'

#Add to a group
Add-AzureADGroupMember -ObjectId $ULA.ObjectID -RefObjectId $Rick.ObjectId

#Remove from the same group
Remove-AzureADGroupMember -ObjectId $ULA.ObjectId -MemberId $Rick.ObjectId

#endregion

