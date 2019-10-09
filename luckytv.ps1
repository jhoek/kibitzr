#!/usr/bin/pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1
$ProgressPreference = 'SilentlyContinue'
$DutchCulture = New-Object -TypeName System.Globalization.CultureInfo -ArgumentList 'nl-NL'

Invoke-WebRequest -Uri 'http://www.luckytv.nl/afleveringen/' `
| Select-Object -ExpandProperty Content `
| pup --plain 'article.video div json{}' `
| ConvertFrom-Json -AsHashtable `
| ForEach-Object { $_.GetEnumerator() } `
| ForEach-Object {
    $Link = $_['children'][0]
    $MetaData = $_['children'][1]
    $Preview = $_['children'][0]['children'][0].src
    $Title = $MetaData['children'][0]['children'][0].text
    $DateElements = ($MetaData['children'][1].text -split ' ')
    $DateText = "$($DateElements[1]) $($DateElements[2]). $($DateElements[3])"
    $Date = [DateTime]::ParseExact($DateText, 'd MMM yyyy', $DutchCulture)
    $Url = $Link.href

    Send-KibitzrNotification `
        -Url $Url `
        -ApplicationToken afbzfvwfwjq5ritp51kw26sivnm1jj `
        -Recipient g5tfftqv8uhg7xbwxufcy7j6keuso1 `
        -Message $Title `
        -Title ('LuckyTV {0:dddd d MMMM yyyy}' -f $Date) `
        -ImageUrl $Preview
}