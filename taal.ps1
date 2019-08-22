#!/usr/bin/pwsh
. $PSScriptRoot/Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'
$DutchCulture = New-Object -TypeName System.Globalization.CultureInfo -ArgumentList 'nl-NL'

Invoke-WebRequest -Uri https://www.trouw.nl/dossier/taal `
| Select-Object -ExpandProperty Content `
| pup 'article > a:first-of-type attr{href}' --plain `
| ForEach-Object {
    $Url = "https://trouw.nl{0}" -f $_
    $Content = Invoke-WebRequest -Uri $Url | Select-Object -ExpandProperty Content
$Title = $Content | pup 'h1 text{}' --plain
$Body = ($Content | pup 'p.artstyle__text text{}' --plain) -join "`n"
$DateText = $Content | pup 'time text{}' --plain
$Date = [DateTime]::ParseExact($DateText, 'd MMMM yyyy , H:mm', $DutchCulture)

Save-EntryToAirTable -TableName taal -Url $Url -Title $Title -Body $Body -Date $Date -Verbose
}