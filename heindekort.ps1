#!/usr/bin/pwsh

. $PSScriptRoot/Send-KibitzrNotification.ps1

Invoke-WebRequest -Uri 'https://www.parool.nl/gs-b738ae8f'
| Select-Object -ExpandProperty Content
| pup 'figure json{}' --plain
| jq '[ .[].children[0].children[0] | { date: .\"data-title\", url: .\"data-original\" } ]'
| ConvertFrom-Json
| ForEach-Object {
    Send-KibitzrNotification `
        -Url $_.url `
        -ApplicationToken ai3c172orj2cvxtcyti3pv6o9y3beh `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Message "$($_.date)" `
        -ImageUrl $_.url
}