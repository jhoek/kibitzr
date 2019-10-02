#!/usr/bin/pwsh
. $PSScriptRoot/Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri 'https://www.nrc.nl/rubriek/kamagurka/' `
| Select-Object -ExpandProperty Content `
| pup '.nmt-item a json{}' --plain `
| ConvertFrom-Json -Depth 10 -AsHashtable `
| ForEach-Object { $_.GetEnumerator() } `
| ForEach-Object {
    $Url = [regex]::Match($_.children[0].children[0].children[1].text, 'src="(.*)"').Groups[1].Value
    $Body = "https://www.nrc.nl$($_.href)"
    $DateElements = $_.href -split '/'
    $Date = Get-Date -Year $DateElements[2] -Month $DateElements[3] -Day $DateElements[4]
    $Title = 'Kamagurka {0:dddd d MMMM yyyy}' -f $Date

    Send-KibitzrNotification `
        -Url $Url `
        -ApplicationToken aRkTUg5jtr9pSDQBPYwPN9X5dP2mHB `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Message $Body `
        -Title $Title `
        -ImageUrl $Url
}