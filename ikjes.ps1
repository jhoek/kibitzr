#!/usr/bin/pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri https://www.nrc.nl/rubriek/ikje `
| Select-Object -ExpandProperty Content `
| pup '.compact-grid__item a attr{href}' --plain `
| Select-Object -First 10 `
| ForEach-Object {
    $Url = "https://www.nrc.nl$($_)"
    $DateText = (($Url -split '/')[4..6]) -join '-'
    $Content = Invoke-WebRequest -Uri $Url | Select-Object -ExpandProperty Content
    $Title = ($Content | pup 'h1[data-flowtype="headline"] text{}' --plain)
    $Body = ($Content | pup 'div.content p text{}' --plain) -join ' '
    $Date = [DateTime]::ParseExact($DateText, 'yyyy-MM-dd', $null)

    Send-KibitzrNotification `
        -ApplicationToken arp51yjfkhaxaptx2t3ymps5jr781c `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Message $Body `
        -Title ("Ikje: $Title ({0:dddd d MMMM yyyy})" -f $Date) `
        -Url $Url
}