. $PSScriptRoot/Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri https://www.nrc.nl/nieuws/ `
| Select-Object -ExpandProperty Content `
| pup '.nmt-item__inner json{}' --plain `
| ConvertFrom-Json `
| ForEach-Object { $_.GetEnumerator() } `
| Select-Object -ExpandProperty children `
| ForEach-Object {
    $Url = "https://www.nrc.nl$($_.href)"
    $SubTitle = $_.children[1].children[0].children[0].text
    $MainTitle = $_.children[1].children[1].text
    $Title = "$SubTitle - $MainTitle"
    $Body = $_.children[1].children[2].text
    $DateElements = ($_.href -split '/')[2..4]
    $Date = Get-Date -Year $DateElements[0] -Month $DateElements[1] -Day $DateElements[2]

    Save-EntryToAirTable -TableName nrcnieuws -Url $Url -Date $Date -Title $Title -Body $Body    
}