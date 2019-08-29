Invoke-WebRequest -Uri https://www.nrc.nl/nieuws/ `
| Select-Object -ExpandProperty Content `
| pup '.nmt-item__inner json{}' --plain `
| ConvertFrom-Json `
| ForEach-Object { $_.GetEnumerator() } `
| Select-Object -ExpandProperty children `
| ForEach-Object {
    $Link = $_.$href
    $_ `
    | Select-Object -ExpandProperty children `
    | gm
}