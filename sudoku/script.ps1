. ../Save-EntryToAirTable.ps1
$ProgressPreference = 'SilentlyContinue'

Invoke-WebRequest -Uri 'https://www.nrc.nl/rubriek/sudoku/' `
| Select-Object -ExpandProperty Content `
| pup --plain '.nmt-item__link json{}' `
| ConvertFrom-Json -Depth 10 `
| ForEach-Object { $_.GetEnumerator() } `
| ForEach-Object {
    $null = ($_.children[0].children[0].children[1].text) -match 'src="(.*?)"'

    $Body = '<img src="{0}"></img>' -f $Matches[1]
    $Url = 'https://www.nrc.nl{0}' -f $_.href
    $DateElements = ($_.href) -split '/'
    $Date = Get-Date -Year $DateElements[2] -Month $DateElements[3] -Day $DateElements[4]

    Save-EntryToAirTable -TableName sudoku -Url $Url -Date $Date -Title Sudoku -Body $Body
}