#region demo
Throw 'This is a demo, dummy!'
#endregion

#region prep
Get-Mailbox -Identity rick.sanchez@office365courses.com | Set-CASMailbox -PopEnabled $true -ImapEnabled $true
Set-MailboxAutoReplyConfiguration -Identity rick.sanchez@office365courses.com -ExternalMessage '' -InternalMessage '' -AutoReplyState Disabled
Remove-Mailbox 'Garage@office365courses.com' -Confirm:$false
Function Prompt(){}
Clear-Host
#endregion

#region connection

#In case we're not connected from part 1:
$credential = Get-Credential

$ExchangeSessionParams = @{
    'ConfigurationName' = 'Microsoft.Exchange'
    'ConnectionUri' = "https://outlook.office365.com/powershell-liveid/"
    'Credential' = $credential
    'Authentication' = 'Basic'
    'AllowRedirection' = $true
}
$exchangeSession = New-PSSession  @ExchangeSessionParams
Import-PSSession $exchangeSession -AllowClobber

#endregion

#region Mailbox Protocols
Get-Mailbox -Identity rick.sanchez@office365courses.com

Get-CASMailbox -Identity rick.sanchez@office365courses.com

Set-CASMailbox -Identity rick.sanchez@office365courses.com -PopEnabled $false -ImapEnabled $false

Get-CASMailbox -Identity rick.sanchez@office365courses.com

Get-Mailbox | Set-CASMailbox -PopEnabled $false -ImapEnabled $false
#endregion

#region AutoReply
Get-MailboxAutoReplyConfiguration -Identity rick.sanchez@office365courses.com

$AutoReply = @{
    'Identity' = 'Rick.Sanchez@office365courses.com'
    'AutoReplyState' = 'Enabled'
    'ExternalMessage' = "I'll be out for a while with the grandkids, back on the 2nd!"
    'InternalMessage' = "I'll be out for a while with the grandkids, back on the 2nd!"
}

Set-MailboxAutoReplyConfiguration @AutoReply

Get-MailboxAutoReplyConfiguration -Identity 'Rick.Sanchez@office365courses.com'

$AutoReply = @{
    'Identity' = 'Rick.Sanchez@office365courses.com'
    'AutoReplyState' = 'Scheduled'
    'StartTime' = '12/20/2018 17:00:00'
    'EndTime' = '01/02/19 08:00:00'
    'ExternalAudience' = 'All' # Known | None
    'InternalMessage' = "<html><body>Thanks for reaching out, I'm enjoying Christmas with my grandkids.<br><br>Wubba lubba dub dub!<br>-Rick</body></html>"
    'ExternalMessage' = "<html><body>Thanks for reaching out, I'm enjoying Christmas with my grandkids.<br><br>Wubba lubba dub dub!<br>-Rick</body></html>"
}
Set-MailboxAutoReplyConfiguration @AutoReply

Get-MailboxAutoReplyConfiguration 'Rick.Sanchez@office365courses.com'

#endregion

#region Create a resource mailbox
$ResourceMailbox = @{
    'Room' = $true
    'Name' = 'Garage'
}
New-Mailbox @ResourceMailbox

New-Mailbox -Name 'Garage' -Room

$CalendarProcessing = @{
    'Identity' = 'Garage@office365courses.com'
    'AllowConflicts' = $false
    'AllowRecurringMeetings' = $true
    'AutomateProcessing' = 'AutoAccept' #None | AutoUpdate
    'BookingWindowInDays' = 365
    'MaximumDurationInMinutes' = 600
    'ProcessExternalMeetingMessages' = $false
}
Set-CalendarProcessing @CalendarProcessing

Get-CalendarProcessing 'Garage@office365courses.com' | Format-List

#endregion

#region mailbox permissions
Get-MailboxPermission 'Rick.Sanchez@office365courses.com'

Get-MailboxPermission 'Rick.Sanchez@office365courses.com' | Where-Object IsInherited -eq $false

$MailboxPermission = @{
    'Identity' = 'Rick.Sanchez@office365courses.com'
    'User' = 'admin@office365courses.com'
    'AccessRights' = 'FullAccess'
}
Add-MailboxPermission @MailboxPermission

Get-MailboxPermission 'Rick.Sanchez@office365courses.com' | Where-Object IsInherited -eq $false

Remove-MailboxPermission @MailboxPermission

Get-MailboxPermission 'Rick.Sanchez@office365courses.com' | Where-Object IsInherited -eq $false

#endregion