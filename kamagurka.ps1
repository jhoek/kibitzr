#!/usr/bin/pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri 'https://www.nrc.nl/rubriek/kamagurka/' `
| Select-Object -ExpandProperty Content `
| ForEach-Object { $_ | pup 'a.nmt-item__link json{}' --plain } `
| ConvertFrom-Json -Depth 10 `
| ForEach-Object { $_ } `
| ForEach-Object {
    $Link = 'https://nrc.nl{0}' -f $_.href
    $DateElements = ($Link -split '/')[4..6]
    $Date = Get-Date -Year $DateElements[0] -Month $DateElements[1] -Day $DateElements[2]
    $ImageUrl = (($_.children[0].children[0].children[0].'data-src') -split '\|')[1]

    Send-KibitzrNotification `
        -Url $Link `
        -ApplicationToken as9kziktmqhy28bs287yuytno4iv85 `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Message ('Kamagurka: {0:dddd d MMMM yyyy}' -f $Date) `
        -ImageUrl $ImageUrl
}