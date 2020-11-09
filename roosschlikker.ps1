#!/usr/bin/pwsh
. $PSScriptRoot/Save-EntryToAirTable.ps1

$DutchCulture = [cultureinfo]::GetCultureInfo('nl-NL')

Invoke-WebRequest -Uri https://www.parool.nl/auteur/roos-schlikker
| Select-Object -ExpandProperty Links
| Select-Object -ExpandProperty href
| Where-Object { $_ -like '/columns-opinie/*' -or $_ -like '/ps/*' }
| ForEach-Object {
    $Url = "https://www.parool.nl$($_)"
    $Content = Invoke-WebRequest -Uri $Url | Select-Object -ExpandProperty Content
    $Title = $Content | pup 'h1 text{}' --plain
    $Body = ($Content | pup 'p.artstyle__text text{}' --plain | Where-Object { $_ } | ForEach-Object { $_.Trim() })
    $Date = [DateTime]::ParseExact(($Content | pup '.artstyle__byline__date text{}' --plain), 'd MMMM yyyy', $DutchCulture)

    Save-EntryToAirTable -Url $Url -Date $Date -Title "Roos Schlikker: $Title" -Body $Body -TableName Mail
}