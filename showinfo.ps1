# $GuidHistoryPath = "~/rssguids.txt"
# $GuidHistory = switch (Test-Path -path $GuidHistoryPath)
# {
#     $true { Get-Content -Path $GuidHistoryPath }
#     $false { @() }
# }
# $NewHistory = New-Object -TypeName System.Collections.ArrayList

# Get-RssFeedItem -Uri 'http://showrss.info/user/214003.rss?magnets=true&namespaces=true&name=null&quality=null&re=null' `
# | Where-Object Guid -notin $GuidHistory `
# | Where-Object Guid -notin $NewHistory `
# | ForEach-Object {


#     $NewHistory.Add($_.Guid)
# }

# Add-Content -Path $GuidHistoryPath -Value $NewHistory

. ./Send-KibitzrNotification.ps1

Get-RssFeedItem -Uri 'http://showrss.info/user/214003.rss?magnets=true&namespaces=true&name=null&quality=null&re=null' `
| ForEach-Object {
    Send-KibitzrNotification `
        -ApplicationToken a17ejjb1vto534trjiwtymadjd6prz `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -UniqueID $_.Guid `
        -Message $_.Description
}
