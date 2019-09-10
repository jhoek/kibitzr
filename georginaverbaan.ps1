#!/usr/bin/pwsh
. $PSScriptRoot/Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'
$DutchCulture = New-Object -TypeName System.Globalization.CultureInfo -ArgumentList 'nl-NL'

Invoke-WebRequest -Uri https://www.volkskrant.nl/auteur/georgina-verbaan `
| Select-Object -ExpandProperty Content `
| pup 'article a attr{href}' `
| ForEach-Object {
    $Url = "https://volkskrant.nl$($_)"
    $Content = Invoke-WebRequest -Uri $Url | Select-Object -ExpandProperty Content
    $Title = $Content | pup 'h1 text{}' --plain
    $Body = $Content | pup 'section.artstyle__main--container p text{}' --plain | ForEach-Object { $_; '' }
    $DateText = $Content | pup 'time span:first-child text{}'
    $Date = [DateTime]::ParseExact($DateText, 'd MMMM yyyy', $DutchCulture)

    Save-EntryToAirTable -TableName georginaverbaan -Url $Url -Date $Date -Title "Georgina Verbaan: $Title" -Body $Body
}