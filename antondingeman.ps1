#!/usr/bin/pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1

Invoke-WebRequest -Uri https://www.trouw.nl/cartoons/de-wereld-van-anton-dingeman~b21b94dc/ `
| Select-Object -ExpandProperty Content `
| pup 'img.artstyle__image attr{data-original}' --plain `
| ForEach-Object {
    Send-KibitzrNotification `
        -Url $_ `
        -ApplicationToken ag9ia4c3jxjny1mom7ordesj7ndnfd `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Title ('Anton Dingeman {0:dddd d MMMM yyyy}' -f (Get-Date)) `
        -Message 'Anton Dingeman' `
        -ImageUrl $_
}