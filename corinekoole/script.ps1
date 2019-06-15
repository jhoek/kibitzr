Invoke-WebRequest -Uri https://www.volkskrant.nl/auteur/corine-koole `
| Select-Object -ExpandProperty Content `
| pup 'article a attr{href}' `
| ForEach-Object {
    $Content = Invoke-WebRequest -Uri "https://volkskrant.nl$($_)" `
    | Select-Object -ExpandProperty Content

$Content | pup 'h1 text{}'
#$Content | pup 'section.artstyle__main--container p' | ForEach-Object { $_; '' }
}