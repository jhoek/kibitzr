. $PSScriptRoot/Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri https://www.nrc.nl/nieuws/ `
| Select-Object -ExpandProperty Content `
| pup '.nmt-item__inner json{}' --plain `
| jq '[.[] | { url:.children[0].href, subtitle:.children[0].children[1].children[0].children[0].text, maintitle:.children[0].children[1].children[1].text, body:.children[0].children[1].children[2].text, body1:.children[0].children[1].children[2].children[0].text }]' `
| ConvertFrom-Json `
| ForEach-Object { $_.GetEnumerator() } `
| ForEach-Object {
    $Url = "https://www.nrc.nl$($_.url)"
    $Title = "$($_.SubTitle) - $($_.MainTitle)"
    $Body = $_.body + $_.body1
    $DateElements = ($_.url -split '/')[2..4]
    $Date = Get-Date -Year $DateElements[0] -Month $DateElements[1] -Day $DateElements[2]
    Save-EntryToAirTable -TableName nrcnieuws -Url $Url -Date $Date -Title $Title -Body $Body    
}