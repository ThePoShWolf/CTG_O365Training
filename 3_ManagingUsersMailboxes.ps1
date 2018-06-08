#region demo
Throw 'This is a demo, dummy!'
#endregion


#region Mailbox Protocols
Get-CASMailbox -Identity rick.sanchez@office365courses.com

Set-CASMailbox -Identity -PopEnabled $false -ImapEnabled $false

Get-Mailbox | Set-CASMailbox -PopEnabled $false -ImapEnabled $false
#endregion

#region AutoReply
Get-MailboxAutoReplyConfiguration -Identity rick.sanchez@office365courses.com

$AutoReply = @{
    'Identity' = 'Rick.Sanchez@office365courses.com'
    'AutoReplyState' = 'Scheduled'
    'StartTime' = '12/20/2018 17:00:00'
    'EndTime' = '01/02/19 08:00:00'
}

Set-MailboxAutoReplyConfiguration @AutoReply

Get-MailboxAutoReplyConfiguration -Identity $AutoReply.Identity

$AutoReply = @{
    'Identity' = 'Rick.Sanchez@office365courses.com'
    'AutoReplyState' = 'Scheduled'
    'StartTime' = '12/20/2018 17:00:00'
    'EndTime' = '01/02/19 08:00:00'
    'ExternalAudience' = 'All'
    'InternalMessage' = "<html><body>Thanks for reaching out, I'm enjoying Christmas with my grandkids.<br><br>Wubba lubba dub dub!<br>-Rick</body></html>"
    'ExternalMessage' = "<html><body>Thanks for reaching out, I'm enjoying Christmas with my grandkids.<br><br>Wubba lubba dub dub!<br>-Rick</body></html>"
}
Set-MailboxAutoReplyConfiguration @AutoReply

Get-MailboxAutoReplyConfiguration $AutoReply.Identity

#endregion

#region Create a resource mailbox
$ResourceMailbox = @{
    'Room' = $true
    'Name' = 'Garage'
    #'DisplayName' = 'Garage'
}
New-Mailbox @ResourceMailbox

$CalendarProcessing = @{
    'Identity' = 'Garage@office365courses.com'
    'AllowConflicts' = $false
    'AllowRecurringMeetings' = $true
    'AutomateProcessing' = 'AutoAccept'
    'BookingWindowInDays' = 365
    'MaximumDurationInMinutes' = 600
    'ProcessExternalMeetingMessages' = $false
}
Set-CalendarProcessing @CalendarProcessing

Get-CalendarProcessing $CalendarProcessing.Identity

#endregion

#region mobile devices

#used to be: Get-ActiveSynceDevice
Get-MobileDevice -Mailbox 'Rick.Sanchez@office365courses.com'

$MobileDevice = @{
    'Identity' = 'Rick.Sanchez@office365courses.com'
    'RequireDeviceEncryption' = $true
    'RequireStorageCardEncryption' = $true
    'PasswordEnabled' = $true
    'MinPasswordLength' = 8
    'MaxPasswordFailedAttempts' = 5
}
Set-MobileDevice @MobileDevice

#endregion

#region mailbox permissions
$MailboxPermission = @{
    'Identity' = 'Rick.Sanchez@office365courses.com'
    'User' = 'admin@office365courses.com'
    'AccessRights' = 'FullAccess'
    'Confirm' = $false
}
Add-MailboxPermission @MailboxPermission

Get-MailboxPermission $MailboxPermission.Identity | Where-Object User -like "*admin*"

Remove-MailboxPermission @MailboxPermission

Get-MailboxPermission $MailboxPermission.Identity | Where-Object User -like "*admin*"

#endregion