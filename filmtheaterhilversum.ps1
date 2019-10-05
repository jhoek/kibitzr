#!/usr/bin/pwsh
. $PSScriptRoot/Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri https://www.filmtheaterhilversum.nl/films/ `
| Select-Object -ExpandProperty Content `
| pup '.film-index__film attr{href}' --plain `
| ForEach-Object {
    $Url = "https://www.filmtheaterhilversum.nl$($_)"
    $Content = Invoke-WebRequest -Uri $Url | Select-Object -ExpandProperty Content
    $Title = ($Content | pup 'h1.featured__title text{}' --plain)
    $Body = ($Content | pup '.film__synopsis__intro text{}' --plain) -join ' '
    $Date = Get-Date

    Save-EntryToAirTable -Url $Url -Date $Date -Title "Filmtheater Hilversum: $Title" -Body $Body
}