Invoke-WebRequest -Uri https://www.volkskrant.nl/auteur/Sylvia%20Witteman `
| Select-Object -ExpandProperty Content `
| pup 'article a attr{href}' `
| Select-Object -First 1 `
| ForEach-Object {     
    $Content = Invoke-WebRequest -Uri "https://volkskrant.nl$($_)" `
    | Select-Object -ExpandProperty Content

    $Heading = $Content | pup 'h1 text{}'
    $Content | pup 'section.artstyle__main--container p' | ForEach-Object { $_; '' }
}