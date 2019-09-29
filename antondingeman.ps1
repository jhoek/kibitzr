#!/usr/bin/pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1

Invoke-WebRequest -Uri https://www.trouw.nl/cartoons/de-wereld-van-anton-dingeman~b21b94dc/ `
| Select-Object -ExpandProperty Content `
| pup 'img.artstyle__image attr{data-original}' --plain `
| ForEach-Object {
    Send-KibitzrNotification `
        -Url $Url `
        -ApplicationToken aRkTUg5jtr9pSDQBPYwPN9X5dP2mHB `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Message 'Anton Dingeman' `
        -ImageUrl $_
}