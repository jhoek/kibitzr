. ../Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'
$DutchCulture = New-Object -TypeName System.Globalization.CultureInfo -ArgumentList 'nl-NL'

Invoke-WebRequest -Uri https://trouw.nl/bert-keizer~d5840135188caea36a9581181 `
| Select-Object -ExpandProperty Content `
| pup 'article > a:first-of-type attr{href}' `
| ForEach-Object {
    $Url = "https://trouw.nl{0}" -f $_
    $Content = Invoke-WebRequest -Uri $Url | Select-Object -ExpandProperty Content
$Title = $Content | pup 'h1 text{}'
$Body = $Content | pup --plain 'p.article__paragraph text{}'
$DateText = $Content | pup 'time text{}'
$Date = [DateTime]::ParseExact($DateText, 'HH:mm, d MMMM yyyy', $DutchCulture)

Save-EntryToAirTable -TableName bertkeizer -Url $Url -Title $Title -Body $Body -Date $Date
}