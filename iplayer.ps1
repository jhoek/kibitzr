#!/usr/bin/env pwsh

Find-AirTableRecord -BaseName appgyJZy5Dkjup0K4 -TableName Programmes `
| ForEach-Object { Write-Host "Program $($_.Name)"; $_ } `
| ForEach-Object { & get_iplayer --pid-recursive-list "$($_.Url)" } `
| Where-Object { $_ } `
| Where-Object { $_ -notmatch '^Episodes:' } `
| Where-Object { $_ -notmatch '^INFO:' } `
| ForEach-Object { Write-Host "Found episode '$_'"; $_ } `
| ForEach-Object { $null = $_ -match '^(?<EpisodeTitle>.*), (?<Channel>.*), (?<ID>.*)$'; @{PID = $Matches.ID; Title = $Matches.EpisodeTitle } } `
| Where-Object { -not (Test-AirTableRecord -BaseName appgyJZy5Dkjup0K4 -TableName Episodes -FieldName PID -Value ($_.PID)) } `
| ForEach-Object { Send-PushoverNotification -ApplicationToken a4fo9r2dmbnjh8hk1m98zhich53e32 -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp -Message "New episode available: $($_.Title)"; $_ } `
| ForEach-Object { New-AirTableRecord -BaseName appgyJZy5Dkjup0K4 -TableName Episodes -Fields $_ }