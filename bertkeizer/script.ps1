. ../Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri https://trouw.nl/bert-keizer~d5840135188caea36a9581181 `
| Select-Object -ExpandProperty Content `
| pup 'article > a:first-of-type attr{href}' `
| ForEach-Object {
    $Url = "https://trouw.nl{0}" -f $_
    $Content = Invoke-WebRequest -Uri $Url | Select-Object -ExpandProperty Content
$Title = $Content | pup 'h1 text{}'
$Body = $Content | pup --plain 'p.article__paragraph text{}'

Save-EntryToAirTable -TableName bertkeizer -Url $Url -Title $Title -Body $Body
}