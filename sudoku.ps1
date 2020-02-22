#!/usr/bin/pwsh
. $PSScriptRoot/Send-KibitzrNotification.ps1
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri 'https://www.nrc.nl/rubriek/sudoku/' `
| Select-Object -ExpandProperty Content `
| pup '.compact-grid__item a attr{href}' --plain `
| Select-Object -First 10 `
| ForEach-Object {
    $Url = "https://www.nrc.nl$($_)"
    $DateElements = $_ -split '/'
    $Date = Get-Date -Year $DateElements[2] -Month $DateElements[3] -Day $DateElements[4]

    Send-KibitzrNotification `
        -Url $Url `
        -ApplicationToken av5b3yspt9nzrphgdpq135fa64do6j `
        -Recipient u65ckN1X5uHueh7abnWukQ2owNdhAp `
        -Message ('{0:dddd d MMMM yyyy}' -f $Date) `
        -Priority Lowest `
        -Title Sudoku `
        -ImageUrl (Invoke-WebRequest -Uri $Url).Images.src
}