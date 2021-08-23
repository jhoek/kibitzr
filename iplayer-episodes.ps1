#!/usr/bin/env pwsh
Add-Type -AssemblyName System.Web

. "$PSScriptRoot/Send-KibitzrNotification.ps1"

$ApplicationToken = 'a4fo9r2dmbnjh8hk1m98zhich53e32'
$Recipient = 'u65ckN1X5uHueh7abnWukQ2owNdhAp'

$env:GETIPLAYERUSERPREFS = '/Users/jhoek/Dropbox/.iPlayer'

Write-Host "$(Get-Date) $('#' * 60)"
get_iplayer --prefs-show

& get_iplayer --pvr --test 2>&1
| ForEach-Object { $_.Exception.Message }
| Where-Object { [bool]$_ }
| Where-Object { $_ -notmatch '^Running PVR Searches:' }
| Where-Object { $_ -notmatch '^Episodes:' } `
| Where-Object { $_ -notmatch '^INFO:' }
| ForEach-Object { Write-Host "- $_"; $_ } `
| ForEach-Object { $null = $_ -match '^(?<EpisodeTitle>.*), (?<Channel>.*), (?<ID>.*)$'; @{PID = $Matches.ID; Title = $Matches.EpisodeTitle } } `
| ForEach-Object {
    $NotificationSent = Send-KibitzrNotification `
        -Url $_.PID `
        -UniqueID $_.PID `
        -ApplicationToken $ApplicationToken `
        -Recipient $Recipient `
        -Message "New episode available: $($_.Title)" `
        -TableName iplayer

    if ($NotificationSent)
    {
        $Url = "things:///add?title=iPlayer: $($_.Title)"
        $EncodedUrl = [uri]::EscapeUriString($Url)
        /usr/bin/open $EncodedUrl
    }
}