. ../Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri https://www.volkskrant.nl/auteur/Sylvia%20Witteman `
| Select-Object -ExpandProperty Content `
| pup 'article a attr{href}' `
| ForEach-Object {
    $Url = "https://volkskrant.nl$($_)"
    $Content = Invoke-WebRequest -Uri $Url | Select-Object -ExpandProperty Content

$Title = $Content | pup 'h1 text{}'
$Body = $Content | pup 'section.artstyle__main--container p' | ForEach-Object { $_; '' }

Save-EntryToAirTable -TableName sylviawitteman -Url $Url -Title $Title
}