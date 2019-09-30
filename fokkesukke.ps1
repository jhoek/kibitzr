#!/usr/bin/pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1

Invoke-WebRequest -Uri 'https://www.nrc.nl/rubriek/fokke-sukke/' `
| Select-Object -ExpandProperty Content `
| ForEach-Object { $_ | pup 'img attr{data-src}' --plain } `
| ForEach-Object { ($_ -split '\|')[1] } `
| ForEach-Object {
    Send-KibitzrNotification `
        -Url $_ `
        -ApplicationToken aRkTUg5jtr9pSDQBPYwPN9X5dP2mHB `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Message 'Fokke & Sukke' `
        -ImageUrl $_
}