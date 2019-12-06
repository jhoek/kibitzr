#!/usr/bin/pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1
Import-Module UncommonSense.Teletekst

Get-TeletekstNews -Type Domestic, Foreign `
| ForEach-Object {
    Send-KibitzrNotification `
        -Url $_.Link `
        -UniqueID "$(Get-Date -Date $_.DateTime -Format 'yyyyMMdd')$($_.Title -replace '''', '')" `
        -ApplicationToken asxmmq8g95jt4ed1qcrucdvu2iuy67 `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Title $_.Title `
        -Message $_.Content
}