#!/usr/bin/pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1

Invoke-WebRequest -Uri 'https://www.nrc.nl/rubriek/ruben-l-oppenheimer/' `
| Select-Object -ExpandProperty Links `
| Select-Object -ExpandProperty href `
| Where-Object { $_ -like '/nieuws/*' } `
| ForEach-Object { "https://www.nrc.nl$($_)" } `
| ForEach-Object {
    $DateElements = ($_ -split '/')[4..6]
    $Date = Get-Date -Year $DateElements[0] -Month $DateElements[1] -Day $DateElements[2]

    $ImageUrl =
        Invoke-WebRequest -Uri $_ `
        | Select-Object -ExpandProperty Content `
        | ForEach-Object { $_ | pup 'img attr{src}' --plain }

    Send-KibitzrNotification `
        -Url $_ `
        -ApplicationToken a7sw8gciyp7mn9ddgi9wcmbd15yk73 `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Message ('{0:dddd d MMMM yyyy}' -f $Date) `
        -ImageUrl $ImageUrl
}