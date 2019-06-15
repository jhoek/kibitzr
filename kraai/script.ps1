. ../Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri https://www.trouw.nl/de-kraai~d10778f08-8c81-490e-a656-93b2f29ac289 `
| Select-Object -ExpandProperty Content `
| pup 'article > a:first-of-type attr{href}' `
| Select-Object -First 1 `
| ForEach-Object {
    $Url = "https://trouw.nl{0}" -f $_
    $Content = Invoke-WebRequest -Uri $Url | Select-Object -ExpandProperty Content
$Title = $Content | pup 'h1 text{}'
$Body = $Content | pup --plain 'p.article__paragraph text{}'
Save-EntryToAirTable -TableName kraai -Url $Url -Title $Title -Body $Body
}