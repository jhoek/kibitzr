#!/usr/bin/pwsh
. ./Send-KibitzrNotification.ps1

Get-RssFeedItem -Uri 'http://showrss.info/user/214003.rss?magnets=true&namespaces=true&name=null&quality=null&re=null' `
| ForEach-Object {
    Send-KibitzrNotification `
        -ApplicationToken a17ejjb1vto534trjiwtymadjd6prz `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -UniqueID $_.Guid `
        -Message $_.Description
}
