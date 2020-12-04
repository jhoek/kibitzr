#!/usr/bin/env pwsh
# TODO: download iplayer config and history from Dropbox
# TODO: configure iplayer to use downloaded config/history
# MAYBE: don't send notification, but add to Things

. ./Send-KibitzrNotification.ps1

Find-AirTableRecord -BaseName appgyJZy5Dkjup0K4 -TableName Programmes `
| ForEach-Object { Write-Host "$($_.Name)" -ForegroundColor Cyan; $_ } `
| ForEach-Object { & get_iplayer --pid-recursive-list "$($_.Url)" } `
| Where-Object { $_ } `
| Where-Object { $_ -notmatch '^Episodes:' } `
| Where-Object { $_ -notmatch '^INFO:' } `
| ForEach-Object { Write-Host "- $_"; $_ } `
| ForEach-Object { $null = $_ -match '^(?<EpisodeTitle>.*), (?<Channel>.*), (?<ID>.*)$'; @{PID = $Matches.ID; Title = $Matches.EpisodeTitle } } `
| ForEach-Object {
    Send-KibitzrNotification `
        -Url $_.PID `
        -UniqueID $_.PID `
        -ApplicationToken a4fo9r2dmbnjh8hk1m98zhich53e32 `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Message "New episode available: $($_.Title)" `
        -TableName iplayer
}