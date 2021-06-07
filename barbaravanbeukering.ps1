#!/usr/bin/pwsh
. $PSScriptRoot/Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'
$DutchCulture = New-Object -TypeName System.Globalization.CultureInfo -ArgumentList 'nl-NL'

Invoke-WebRequest -Uri https://www.volkskrant.nl/auteur/barbara-van-beukering `
| Select-Object -ExpandProperty Content `
| pup 'article a attr{href}' `
| ForEach-Object {
    $Url = "https://volkskrant.nl$($_)"
    $Content = Invoke-WebRequest -Uri $Url | Select-Object -ExpandProperty Content
    $Title = $Content | pup 'h1 text{}' --plain
    $Body = ($Content | pup 'section.artstyle__main--container p text{}' --plain) -join "`n`n"
    $DateText = ($Content | pup 'time span text{}' --plain) -join ''
    $Date = [DateTime]::ParseExact($DateText, 'd MMMM yyyy, H:mm', $DutchCulture)

    Save-EntryToAirTable -Url $Url -Title "Barbara van Beukering: $Title" -Date $Date -Body $Body -Table mail
}