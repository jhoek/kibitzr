. ./Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri 'https://www.nrc.nl/rubriek/scrypto/' `
| Select-Object -ExpandProperty Content `
| pup --plain '.compact-grid__item attr{data-article-url}' `
| ForEach-Object {
    $DateElements = $_ -split '/'
    $Date = Get-Date -Year $DateElements[4] -Month $DateElements[5] -Day $DateElements[6]
    Save-EntryToAirTable -TableName scrypto -Url $_ -Date $Date -Title ('Scrypto {0:dddd d MMMM yyyy}' -f $Date)
}