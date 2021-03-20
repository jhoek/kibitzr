#!/usr/bin/env pwsh
Add-Type -AssemblyName System.Web

. "$PSScriptRoot/Send-KibitzrNotification.ps1"

$ApplicationToken = 'a4fo9r2dmbnjh8hk1m98zhich53e32'
$Recipient = 'u65ckN1X5uHueh7abnWukQ2owNdhAp'

Write-Host "$(Get-Date) $('#' * 60)"
get_iplayer --prefs-show

Find-AirTableRecord `
    -ApiKey keyL62zvsXw1vBbKZ `
    -BaseName appgyJZy5Dkjup0K4 `
    -TableName Programmes `
| Where-Object Name -like 'The Ran*' `
| ForEach-Object { Write-Host "$($_.Name)" -ForegroundColor Cyan; $_ } `
| ForEach-Object { get_iplayer --pid-recursive-list "$($_.Url)"; '' } `
| Where-Object { $_ } `
| Where-Object { $_ -notmatch '^Episodes:' } `
| Where-Object { $_ -notmatch '^INFO:' } `
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
        open $EncodedUrl
    }
}