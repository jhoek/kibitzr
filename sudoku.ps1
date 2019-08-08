#!/usr/bin/pwsh
. $PSScriptRoot/Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri 'https://www.nrc.nl/rubriek/sudoku/' `
| Select-Object -ExpandProperty Content `
| pup '.compact-grid__item a attr{href}' --plain `
| Select-Object -First 10 `
| ForEach-Object {
    $Url = "https://www.nrc.nl$($_)"
    $DateElements = $_ -split '/'
    $Date = Get-Date -Year $DateElements[2] -Month $DateElements[3] -Day $DateElements[4]
    $Image = (Invoke-WebRequest -Uri $Url).Images.src
    $Title = 'Sudoku {0:dddd d MMMM yyyy}' -f $Date

    Save-EntryToAirTable -TableName sudoku -Url $Image -Date $Date -Title $Title -Body $Url
}