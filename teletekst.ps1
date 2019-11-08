#!/usr/bin/pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1

'https://teletekst-data.nos.nl/webplus?p=102-1',
'https://teletekst-data.nos.nl/webplus?p=103-1' `
| ForEach-Object {
    Invoke-WebRequest -Uri $_ `
    | Select-Object -ExpandProperty Content `
    | pup '#content .yellow json{}' --plain `
    | ConvertFrom-Json `
    | ForEach-Object { $_.GetEnumerator() } `
    | Select-Object @{n = 'Text'; e = { $_.text -replace '\.+', '' } }, @{n = 'Link'; e = { 'https://teletekst-data.nos.nl{0}' -f ($_.children[0].href) } } `
    | Where-Object { $_.Text } `
    | Where-Object Link -notin $null, '', 'https://teletekst-data.nos.nl/webplus?p=199' `
    | ForEach-Object {
        Send-KibitzrNotification `
            -Url $_.Link `
            -UniqueID $_.Text `
            -ApplicationToken asxmmq8g95jt4ed1qcrucdvu2iuy67 `
            -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
            -Message $_.Text
    }
}





