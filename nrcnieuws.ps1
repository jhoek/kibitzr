Invoke-WebRequest -Uri https://www.nrc.nl/nieuws/ `
| Select-Object -ExpandProperty Content `
| pup '.nmt-item__inner json{}' --plain `
| ConvertFrom-Json `
| ForEach-Object { $_.GetEnumerator() } `
| Select-Object -ExpandProperty children `
| ForEach-Object {
    $Link = $_.$href
    $Title = "$($_.children[1].children[0].children[0].text): $($_.children[1].children[1].text)"
    $Body = $_.children[1].children[2].children[0].text
    $Body
}