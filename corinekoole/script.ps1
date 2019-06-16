. ../Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'
$DutchCulture = New-Object -TypeName System.Globalization.CultureInfo -ArgumentList 'nl-NL'

Invoke-WebRequest -Uri https://www.volkskrant.nl/auteur/corine-koole `
| Select-Object -ExpandProperty Content `
| pup 'article a attr{href}' `
| ForEach-Object {
    $Url = "https://volkskrant.nl$($_)"
    $Content = Invoke-WebRequest -Uri $Url | Select-Object -ExpandProperty Content
$Title = $Content | pup 'h1 text{}'
$Body = ($Content | pup 'section.artstyle__main--container p text{}') -join "`n`n"
$DateText = ($Content | pup 'time span text{}') -join ''
$Date = [DateTime]::ParseExact($DateText, 'd MMMM yyyy, HH:mm', $DutchCulture)

Save-EntryToAirTable -TableName corinekoole -Url $Url -Title $Title -Date $Date -Body $Body
}